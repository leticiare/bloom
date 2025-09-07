import base64
from datetime import datetime, timedelta, timezone
from io import BytesIO
from pathlib import Path
from typing_extensions import Literal

from domain.entities.EventoAgenda import EventoAgenda
from domain.entities.Gestante import Gestante
from fastapi import Response
from xhtml2pdf import pisa


class ControladorRelatorio:
    def __init__(self):
        self.base_path = Path(__file__).resolve().parent.parent / "templates"

    def gerar_pdf(
        self,
        template_name: str,
        logo_name: str,
        vacinas: list[EventoAgenda],
        consultas: list[EventoAgenda],
        exames: list[EventoAgenda],
        gestante: Gestante,
        tipo_relatorio: Literal["mensal", "completo"] = "completo",
    ) -> bytes:
        caminho_template = self.base_path / template_name
        caminho_logo = self.base_path / "assets" / logo_name

        html_content = caminho_template.read_text(encoding="utf-8")

        with open(caminho_logo, "rb") as f:
            logo_base64 = base64.b64encode(f.read()).decode("utf-8")

        html_content = html_content.replace(
            "{{logo}}", f"data:image/png;base64,{logo_base64}"
        )

        vacinas = self._filtrar_eventos(vacinas, tipo_relatorio)
        consultas = self._filtrar_eventos(consultas, tipo_relatorio)
        exames = self._filtrar_eventos(exames, tipo_relatorio)

        consultas_html = self.renderizar_eventos_html(consultas)
        vacinas_html = self.renderizar_eventos_html(vacinas)
        exames_html = self.renderizar_eventos_html(exames)
        gestante_html = self.renderizar_dados_gestante(gestante)

        html_content = html_content.replace("{relatorio.vacinas}", vacinas_html)
        html_content = html_content.replace("{relatorio.consultas}", consultas_html)
        html_content = html_content.replace("{relatorio.exames}", exames_html)
        html_content = html_content.replace("{relatorio.gestante}", gestante_html)
        html_content = html_content.replace("{relatorio.tipo}", tipo_relatorio)
        result_file = BytesIO()
        pisa_status = pisa.CreatePDF(
            BytesIO(html_content.encode("utf-8")),
            dest=result_file,
            encoding="UTF-8",
        )

        if pisa_status.err:
            raise Exception("Erro ao gerar PDF.")

        result_file.seek(0)
        return result_file.read()

    def _filtrar_eventos(
        self, eventos: list[EventoAgenda], tipo_relatorio: str
    ) -> list[EventoAgenda]:
        if tipo_relatorio == "mensal":
            # O relatório mensal filtra os eventos realizados nos últimos 30 dias
            hoje = datetime.now(timezone.utc)
            limite = hoje - timedelta(days=30)
            eventos_filtrados = []

            for evento in eventos:
                dt = evento.get("data_realizacao")
                if not dt:
                    continue

                if isinstance(dt, str):
                    try:
                        dt = datetime.fromisoformat(dt)
                    except ValueError:
                        continue

                if dt.tzinfo is None:
                    dt = dt.replace(tzinfo=timezone.utc)

                if limite <= dt <= hoje:
                    eventos_filtrados.append(evento)

            return eventos_filtrados

        return eventos

    def relatorio(self) -> Response:
        pdf_bytes = self.gerar_pdf("relatorio.html", "logo-bloom.png")

        headers = {
            "Content-Disposition": 'attachment; filename="RelatorioGestacional-Bloom.pdf"'
        }
        return Response(
            content=pdf_bytes, headers=headers, media_type="application/pdf"
        )

    def formatar_data(self, dt):
        if not dt:
            return "-"
        if isinstance(dt, datetime):
            return dt.strftime("%d/%m/%Y %H:%M")
        # Tenta converter string ISO para datetime
        try:
            dt_obj = datetime.fromisoformat(dt)
            return dt_obj.strftime("%d/%m/%Y %H:%M")
        except Exception:
            return dt  # se não for ISO, retorna como está

    def renderizar_eventos_html(self, eventos: list[EventoAgenda]) -> str:
        if not eventos:
            return "<p>Nenhum evento registrado.</p>"

        html = "<table style='width:100%; border-collapse: collapse;'>"
        html += """
            <tr style='background:#FF3C7D; color:#fff;'>
                <th style='padding:6px; text-align:left;'>Nome</th>
                <th style='padding:6px; text-align:left;'>Descrição</th>
                <th style='padding:6px; text-align:left;'>Realização</th>
            </tr>
        """
        for evento in eventos:
            html += f"""
                <tr style='border-bottom:1px solid #ddd;'>
                    <td style='padding:6px;'>{evento["nome"]}</td>
                    <td style='padding:6px;'>{evento["descricao"]}</td>

                    <td style='padding:6px;'>{self.formatar_data(evento["data_realizacao"]) or "-"}</td>
                </tr>
            """
        html += "</table>"
        return html

    def renderizar_dados_gestante(self, gestante: Gestante):
        html = f""""
        <div class="card">
        <h2>Dados da Gestante</h2>
         </div>
           <div class="info-col">
                <p><strong>Nome:</strong> {gestante.nome}</p>
                <p><strong>Data de Nascimento:</strong> {self.formatar_data(gestante.data_nascimento)}</p>
            </div>
            <div class="info-col">
                <p><strong>Antecedentes Obstetrícios:</strong> {gestante.antecedentes_obstetricos}</p>
                <p><strong>Data da Última Menstruação (DUM):</strong> {self.formatar_data(gestante.dum)}</p>
                <p><strong>Data Provável do Parto (DPP):</strong> {self.formatar_data(gestante.dpp)}</p>
                <p><strong>Antecedentes Familiares:</strong> {gestante.antecedentes_familiares}</p>

            </div>
        
        """
        return html

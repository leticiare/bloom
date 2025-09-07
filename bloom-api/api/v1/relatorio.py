from typing import Literal

from controllers.ControladorConsulta import ControladorConsulta
from controllers.ControladorExame import ControladorExame
from controllers.ControladorGestante import ControladorGestante
from controllers.ControladorRelatorio import ControladorRelatorio
from controllers.ControladorVacina import ControladorVacina
from fastapi import APIRouter, Response

router = APIRouter()
from pydantic import BaseModel


class RequisicaoRelatorio(BaseModel):
    id_gestante: str
    tipo: Literal["mensal", "completo"]


@router.post("/")
async def exportar_pdf_alternativo(requisicao: RequisicaoRelatorio):
    try:
        gestante = ControladorGestante().obter_gestante_por_id(requisicao.id_gestante)
        exames = ControladorExame().obter_exames_realizados(requisicao.id_gestante)
        vacinas = ControladorVacina().obter_vacinas_realizadas(requisicao.id_gestante)
        consultas = ControladorConsulta().obter_consultas_realizadas(
            requisicao.id_gestante
        )

        pdf_bytes = ControladorRelatorio().gerar_pdf(
            template_name="relatorio.html",
            logo_name="logo-bloom.png",
            vacinas=vacinas,
            consultas=consultas,
            exames=exames,
            gestante=gestante,
        )
        headers = {"Content-Disposition": 'attachment; filename="relatorio.pdf"'}
        return Response(
            content=pdf_bytes, media_type="application/pdf", headers=headers
        )

    except Exception as e:
        return Response(f"Ocorreu um erro inesperado: {e}", status_code=500)

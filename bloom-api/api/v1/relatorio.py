from typing import Literal

from controllers.ControladorConsulta import ControladorConsulta
from controllers.ControladorExame import ControladorExame
from controllers.ControladorGestante import ControladorGestante
from controllers.ControladorRelatorio import ControladorRelatorio
from controllers.ControladorVacina import ControladorVacina
from domain.entities.Gestante import Gestante
from fastapi import APIRouter, Depends, Response
from pydantic import BaseModel

from api.middlewares.CurrentUser import perfil_autorizado

router = APIRouter()


class RequisicaoRelatorio(BaseModel):
    tipo: Literal["mensal", "completo"]


@router.post("/")
async def exportar_pdf(
    requisicao: RequisicaoRelatorio,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    try:
        gestante: Gestante = await ControladorGestante().obter_gestante_por_email(
            usuario.get("email")
        )
        exames = ControladorExame().obter_exames_realizados(gestante.id)
        vacinas = ControladorVacina().obter_vacinas_realizadas(gestante.id)
        consultas = ControladorConsulta().obter_consultas_realizadas(gestante.id)

        pdf_bytes = ControladorRelatorio().gerar_pdf(
            template_name="relatorio.html",
            logo_name="logo-bloom.png",
            vacinas=vacinas,
            consultas=consultas,
            exames=exames,
            gestante=gestante,
            tipo_relatorio=requisicao.tipo,
        )
        headers = {"Content-Disposition": 'attachment; filename="relatorio.pdf"'}
        return Response(
            content=pdf_bytes, media_type="application/pdf", headers=headers
        )

    except Exception as e:
        return Response(f"Ocorreu um erro inesperado: {e}", status_code=500)

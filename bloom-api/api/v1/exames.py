from fastapi import APIRouter
from pydantic import BaseModel, Field

from controllers.ControladorExame import ControladorExame
from datetime import datetime
from fastapi.responses import JSONResponse

router = APIRouter()

controlador: ControladorExame = ControladorExame()


class RequisicaoAgendarExame(BaseModel):
    id: str = Field(
        ...,
        description="UUID do exame a ser agendado na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )
    data_agendamento: datetime = Field(
        ...,
        description="Data e hora do agendamento no formato ISO 8601",
        examples=[datetime.now()],
    )


@router.put("/agendar", tags=["Exames"])
def agendar_exame(requisicao: RequisicaoAgendarExame):
    """Agendar um exame da gestante."""
    return JSONResponse(
        content=controlador.agendar_exame(
            data_agendamento=requisicao.data_agendamento, exame_id=requisicao.id
        ),
        status_code=200,
    )

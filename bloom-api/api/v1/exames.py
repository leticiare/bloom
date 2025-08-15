from fastapi import APIRouter, Query
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


class RequisicaoRealizarExame(BaseModel):
    id: str = Field(
        ...,
        description="UUID do exame a ser realizado na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )
    data_realizacao: datetime | None = Field(
        ...,
        description="Data e hora da realização no formato ISO 8601",
        examples=[datetime.now()],
    )


@router.get("/{gestante_id}", tags=["Exames"])
def listar_exames(
    gestante_id: str,
    data_inicio: datetime | None = Query(
        None, description="Data início no formato ISO 8601"
    ),
    data_fim: datetime | None = Query(None, description="Data fim no formato ISO 8601"),
):
    """Listar os exames da gestante. É possível passar um intervalo de datas como parâmetros na url."""
    return JSONResponse(
        content=controlador.obter_todos(
            gestante_id=gestante_id,
            data_inicio=data_inicio,
            data_fim=data_fim,
        ),
        status_code=200,
    )


@router.get("/agendados/{gestante_id}", tags=["Exames"])
def listar_exames_agendados(gestante_id: str):
    """Listar todos os exames agendados da gestante."""
    return JSONResponse(
        content=controlador.obter_exames_agendados(gestante_id=gestante_id),
        status_code=200,
    )


@router.get("/nao-agendados/{gestante_id}", tags=["Exames"])
def listar_exames_nao_agendados(gestante_id: str):
    """Listar todos os exames não agendados da gestante."""
    return JSONResponse(
        content=controlador.obter_exames_nao_agendados(gestante_id=gestante_id),
        status_code=200,
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


@router.put("/realizar", tags=["Exames"])
def realizar_exame(requisicao: RequisicaoRealizarExame):
    """Realizar um exame da gestante."""
    return JSONResponse(
        content=controlador.realizar_exame(
            exame_id=requisicao.id, data_realizacao=requisicao.data_realizacao
        ),
        status_code=200,
    )

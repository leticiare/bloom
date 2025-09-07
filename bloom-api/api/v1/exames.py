from fastapi import APIRouter, Query, Path, Depends
from pydantic import BaseModel, Field

from typing import List

from controllers.ControladorExame import ControladorExame
from controllers.dto.ExameDto import ExameDto
from api.resposta_padrao import RespostaPadrao

from datetime import datetime
from fastapi.responses import JSONResponse
from api.middlewares.CurrentUser import perfil_autorizado

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


class RequisicaoCancelarExame(BaseModel):
    id: str = Field(
        ...,
        description="UUID do exame a ser cancelado na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )


@router.get("/", tags=["Exames"], response_model=RespostaPadrao[List[ExameDto]])
def listar_exames(
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
    data_inicio: datetime | None = Query(
        None, description="Data início no formato ISO 8601"
    ),
    data_fim: datetime | None = Query(None, description="Data fim no formato ISO 8601"),
):
    """Listar os exames da gestante. É possível passar um intervalo de datas como parâmetros na url."""
    return JSONResponse(
        content=controlador.obter_todos(
            gestante_id=usuario.get("id_entidade_perfil"),
            data_inicio=data_inicio,
            data_fim=data_fim,
        ),
        status_code=200,
    )


@router.get(
    "/agendados/",
    tags=["Exames"],
    response_model=RespostaPadrao[List[ExameDto]],
)

def listar_exames_agendados(
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Listar todos os exames agendados da gestante."""
    return JSONResponse(
        content=controlador.obter_exames_agendados(
            gestante_id=usuario.get("id_entidade_perfil")
        ),
        status_code=200,
    )



@router.get(
    "/pendentes/",
    tags=["Exames"],
    response_model=RespostaPadrao[List[ExameDto]],
)
def listar_exames_pendentes(
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):

    """Listar todos os exames pendentes da gestante."""
    return JSONResponse(
       content=controlador.obter_exames_pendentes(
            gestante_id=usuario.get("id_entidade_perfil")
        ),
        status_code=200,
    )

@router.put("/agendar", tags=["Exames"], response_model=RespostaPadrao[ExameDto])
def agendar_exame(
    requisicao: RequisicaoAgendarExame,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Agendar um exame da gestante."""
    return JSONResponse(
        content=controlador.agendar_exame(
            data_agendamento=requisicao.data_agendamento,
            exame_id=requisicao.id,
        ),
        status_code=200,
    )


@router.put("/realizar", tags=["Exames"], response_model=RespostaPadrao[ExameDto])
def realizar_exame(
    requisicao: RequisicaoRealizarExame,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Realizar um exame da gestante."""
    return JSONResponse(
        content=controlador.realizar_exame(
            exame_id=requisicao.id, data_realizacao=requisicao.data_realizacao
        ),
        status_code=200,
    )


@router.put("/remarcar", tags=["Exames"], response_model=RespostaPadrao[ExameDto])
def remarcar_exame(
    requisicao: RequisicaoAgendarExame,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Remarca um exame agendado da gestante."""
    return JSONResponse(
        content=controlador.remarcar_exame(
            exame_id=requisicao.id, data_remarcacao=requisicao.data_agendamento
        ),
        status_code=200,
    )



@router.put("/cancelar", tags=["Exames"], response_model=RespostaPadrao[ExameDto])
def cancelar_exame(
    requisicao: RequisicaoCancelarExame,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Cancela um exame agendado da gestante."""
    return JSONResponse(
        content=controlador.cancelar_exame(exame_id=requisicao.id),
        status_code=200,
    )

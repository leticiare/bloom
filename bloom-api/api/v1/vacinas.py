from fastapi import APIRouter, Depends, Query, Path
from pydantic import BaseModel, Field
from typing import List

from api.middlewares.CurrentUser import perfil_autorizado
from controllers.ControladorVacina import ControladorVacina
from datetime import datetime
from fastapi.responses import JSONResponse
from controllers.dto.VacinaDto import VacinaDto
from api.resposta_padrao import RespostaPadrao

router = APIRouter()

controlador: ControladorVacina = ControladorVacina()


class RequisicaoAgendarVacina(BaseModel):
    id: str = Field(
        ...,
        description="UUID do vacina a ser agendado na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )
    data_agendamento: datetime = Field(
        ...,
        description="Data e hora do agendamento no formato ISO 8601",
        examples=[datetime.now()],
    )


class RequisicaoAplicarVacina(BaseModel):
    id: str = Field(
        ...,
        description="UUID do vacina a ser aplicada na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )
    data_realizacao: datetime | None = Field(
        ...,
        description="Data e hora da realização no formato ISO 8601",
        examples=[datetime.now()],
    )


class RequisicaoCancelarVacina(BaseModel):
    id: str = Field(
        ...,
        description="UUID do vacina a ser cancelada na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )


@router.get("/", tags=["Vacinas"], response_model=RespostaPadrao[List[VacinaDto]])
def listar_vacinas(
    data_inicio: datetime | None = Query(
        None, description="Data início no formato ISO 8601"
    ),
    data_fim: datetime | None = Query(None, description="Data fim no formato ISO 8601"),
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Listar as vacinas da gestante. É possível passar um intervalo de datas como parâmetros na url."""
    return JSONResponse(
        content=controlador.obter_todos(
            gestante_id=usuario.get("id_entidade_perfil"),
            data_inicio=data_inicio,
            data_fim=data_fim,
        ),
        status_code=200,
    )


@router.get(
    "/agendadas/",
    tags=["Vacinas"],
    response_model=RespostaPadrao[List[VacinaDto]],
)
def listar_vacinas_agendadas(
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Listar todas as vacinas agendadas da gestante."""
    return JSONResponse(
        content=controlador.obter_vacinas_agendadas(
            gestante_id=usuario.get("id_entidade_perfil")
        ),
        status_code=200,
    )


@router.get(
    "/pendentes/",
    tags=["Vacinas"],
    response_model=RespostaPadrao[List[VacinaDto]],
)
def listar_vacinas_pendentes(
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Listar todas as vacinas pendentes da gestante."""
    return JSONResponse(
        content=controlador.obter_vacinas_pendentes(
            gestante_id=usuario.get("id_entidade_perfil")
        ),
        status_code=200,
    )


@router.put("/agendar", tags=["Vacinas"], response_model=RespostaPadrao[VacinaDto])
def agendar_vacina(
    requisicao: RequisicaoAgendarVacina,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Agendar uma vacina da gestante."""
    return JSONResponse(
        content=controlador.agendar_vacina(
            data_agendamento=requisicao.data_agendamento, vacina_id=requisicao.id
        ),
        status_code=200,
    )


@router.put("/aplicar", tags=["Vacinas"], response_model=RespostaPadrao[VacinaDto])
def aplicar_vacina(
    requisicao: RequisicaoAplicarVacina,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Aplicar uma vacina da gestante."""
    return JSONResponse(
        content=controlador.aplicar_vacina(
            vacina_id=requisicao.id, data_realizacao=requisicao.data_realizacao
        ),
        status_code=200,
    )


@router.put("/remarcar", tags=["Vacinas"], response_model=RespostaPadrao[VacinaDto])
def remarcar_vacina(
    requisicao: RequisicaoAgendarVacina,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Remarca uma vacina agendada da gestante."""
    return JSONResponse(
        content=controlador.remarcar_vacina(
            vacina_id=requisicao.id, data_remarcacao=requisicao.data_agendamento
        ),
        status_code=200,
    )


@router.put("/cancelar", tags=["Vacinas"], response_model=RespostaPadrao[VacinaDto])
def cancelar_vacina(
    requisicao: RequisicaoCancelarVacina,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Cancela uma vacina agendada da gestante."""
    return JSONResponse(
        content=controlador.cancelar_vacina(vacina_id=requisicao.id),
        status_code=200,
    )

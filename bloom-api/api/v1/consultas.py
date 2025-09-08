from fastapi import APIRouter, Depends, Query, Path
from pydantic import BaseModel, Field
from typing import List, Optional

from controllers.ControladorConsulta import ControladorConsulta
from controllers.dto.ConsultaDto import ConsultaDto
from api.resposta_padrao import RespostaPadrao
from datetime import datetime
from fastapi.responses import JSONResponse
from api.middlewares.CurrentUser import perfil_autorizado

router = APIRouter()

controlador: ControladorConsulta = ControladorConsulta()


class RequisicaoAgendarConsulta(BaseModel):
    id: str = Field(
        ...,
        description="UUID do consulta a ser agendada na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )
    data_agendamento: datetime = Field(
        ...,
        description="Data e hora do agendamento no formato ISO 8601",
        examples=[datetime.now()],
    )


class RequisicaoRealizarConsulta(BaseModel):
    id: str = Field(
        ...,
        description="UUID do consulta a ser realizada na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )
    data_realizacao: Optional[datetime] = Field(
        None,
        description="Data e hora da realização no formato ISO 8601",
        examples=[datetime.now()],
    )


class RequisicaoCancelarConsulta(BaseModel):
    id: str = Field(
        ...,
        description="UUID do consulta a ser cancelada na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )


class RequisicaoAnotarObservacaoConsulta(BaseModel):
    id: str = Field(
        ...,
        description="UUID do consulta a ser anotada na versão 4",
        examples=["123e4567-e89b-12d3-a456-426614174000"],
    )
    observacoes: str = Field(
        ...,
        description="Observações a serem anotadas na consulta",
        examples=["Paciente apresenta sintomas leves"],
    )


@router.get(
    "/",
    tags=["Consultas"],
    response_model=RespostaPadrao[List[ConsultaDto]],
)
def listar_consultas(
    data_inicio: datetime | None = Query(
        None, description="Data início no formato ISO 8601"
    ),
    data_fim: datetime | None = Query(None, description="Data fim no formato ISO 8601"),
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Listar as consultas da gestante. É possível passar um intervalo de datas como parâmetros na url."""
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
    tags=["Consultas"],
    response_model=RespostaPadrao[List[ConsultaDto]],
)
def listar_consultas_agendados(
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Listar todas as consultas agendadas da gestante."""
    return JSONResponse(
        content=controlador.obter_consultas_agendadas(
            gestante_id=usuario.get("id_entidade_perfil")
        ),
        status_code=200,
    )


@router.get(
    "/pendentes/",
    tags=["Consultas"],
    response_model=RespostaPadrao[List[ConsultaDto]],
)
def listar_consultas_pendentes(
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Listar todas as consultas pendentes da gestante."""
    return JSONResponse(
        content=controlador.obter_consultas_pendentes(
            gestante_id=usuario.get("id_entidade_perfil")
        ),
        status_code=200,
    )


@router.put("/agendar", tags=["Consultas"], response_model=RespostaPadrao[ConsultaDto])
def agendar_consulta(
    requisicao: RequisicaoAgendarConsulta,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Agendar uma consulta da gestante."""
    return JSONResponse(
        content=controlador.agendar_consulta(
            data_agendamento=requisicao.data_agendamento, consulta_id=requisicao.id
        ),
        status_code=200,
    )


@router.put("/realizar", tags=["Consultas"], response_model=RespostaPadrao[ConsultaDto])
def realizar_consulta(
    requisicao: RequisicaoRealizarConsulta,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Realizar uma consulta da gestante. Se a data de realização não for informada, a data de agendamento será utilizada."""
    return JSONResponse(
        content=controlador.realizar_consulta(
            consulta_id=requisicao.id, data_realizacao=requisicao.data_realizacao
        ),
        status_code=200,
    )


@router.put(
    "/remarcar",
    tags=["Consultas"],
    response_model=RespostaPadrao[ConsultaDto],
)
def remarcar_consulta(
    requisicao: RequisicaoAgendarConsulta,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Remarca uma consulta agendada da gestante."""
    return JSONResponse(
        content=controlador.remarcar_consulta(
            consulta_id=requisicao.id, data_remarcacao=requisicao.data_agendamento
        ),
        status_code=200,
    )


@router.put("/cancelar", tags=["Consultas"], response_model=RespostaPadrao[ConsultaDto])
def cancelar_consulta(
    requisicao: RequisicaoCancelarConsulta,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Cancela uma consulta agendada da gestante."""
    return JSONResponse(
        content=controlador.cancelar_consulta(consulta_id=requisicao.id),
        status_code=200,
    )


@router.put("/anotar", tags=["Consultas"], response_model=RespostaPadrao[ConsultaDto])
def anotar_observacao_consulta(
    requisicao: RequisicaoAnotarObservacaoConsulta,
    usuario: dict = Depends(perfil_autorizado(["gestante"])),
):
    """Anota uma observação em uma consulta da gestante."""
    return JSONResponse(
        content=controlador.anotar_observacao_consulta(
            consulta_id=requisicao.id, observacoes=requisicao.observacoes
        ),
        status_code=200,
    )

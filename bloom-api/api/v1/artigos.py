from controllers.ControladorArtigo import ControladorArtigo
from controllers.dto.ArtigoDTO import ArtigoDTO
from controllers.dto.FiltroConsultaDTO import FiltroConsultaDTO
from domain.entities.Artigo import Artigo
from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse

from ..middlewares.CurrentUser import perfil_autorizado

router = APIRouter()

controlador = ControladorArtigo()


@router.post("/registrar")
async def registrar(
    artigo: ArtigoDTO, current_user: dict = Depends(perfil_autorizado(["profissional"]))
):
    controlador.escrever_artigo(artigo, current_user.get("email"))
    return JSONResponse(status_code=200, content=artigo.model_dump())


@router.delete("/excluir")
async def excluir(
    id_artigo: str, current_user: dict = Depends(perfil_autorizado(["profissional"]))
):
    controlador.excluir_artigo(id_artigo=id_artigo, usuario=current_user.get("email"))
    return JSONResponse(
        status_code=200, content={"Response": "Artigo excluído com sucesso!"}
    )


@router.put("/editar")
async def editar(
    artigo: ArtigoDTO, current_user: dict = Depends(perfil_autorizado(["profissional"]))
):
    controlador.editar_artigo(artigo_dto=artigo, usuario=current_user.get("email"))
    return JSONResponse(
        status_code=200, content={"Response": artigo.dict(exclude_none=True)}
    )


@router.post("/consultar")
async def consultar(
    filtro: FiltroConsultaDTO = None,
    current_user: dict = Depends(perfil_autorizado(["profissional", "gestante"])),
):
    artigos = controlador.obter(filtro)
    return JSONResponse(
        status_code=200,
        content={
            "filtros_aplicados": filtro.dict(exclude_none=True)
            if filtro
            else "Nenhum filtro aplicado",
            "artigos": [artigo.para_dicionario() for artigo in artigos],
        },
    )

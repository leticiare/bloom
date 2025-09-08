from auth.AuthService import autenticacao
from controllers.dto.GestanteDto import GestanteDTO
from controllers.dto.ProfissionalDto import ProfissionalDTO
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel, EmailStr

from ..middlewares.CurrentUser import get_current_user, perfil_autorizado
from domain.services.PerfilService import PerfilService

router = APIRouter()
service_perfil = PerfilService()


class RequisicaoLogin(BaseModel):
    email: EmailStr
    senha: str


@router.post("/registro/gestante")
async def registrar_gestante(gestante_dto: GestanteDTO):
    gestante = gestante_dto.para_entidade()
    try:
        resposta = await autenticacao.registrar_usuario(gestante)
        return JSONResponse(status_code=200, content={"Response": resposta})
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/registro/profissional")
async def registrar_profissional(profissional_dto: ProfissionalDTO):
    profissional = profissional_dto.para_entidade()
    try:
        resposta = await autenticacao.registrar_usuario(profissional)
        return JSONResponse(status_code=200, content={"Response": resposta})
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/login")
async def login(usuario: RequisicaoLogin):
    try:
        resultado = await autenticacao.login(usuario)
        return resultado
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))


@router.get("/perfil")
async def perfil(current_user: dict = Depends(get_current_user)):
    usuario = await service_perfil.obter_por_perfil(
        email=current_user.get("email"), perfil=current_user.get("perfil")
    )
    return JSONResponse(status_code=200, content={"Response": usuario.to_dict()})

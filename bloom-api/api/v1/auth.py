from auth.AuthService import autenticacao
from controllers.dto.GestanteDto import GestanteDTO
from controllers.dto.ProfissionalDto import ProfissionalDTO
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel, EmailStr

from ..middlewares.CurrentUser import perfil_autorizado

router = APIRouter()


class RequisicaoLogin(BaseModel):
    email: EmailStr
    senha: str


@router.post("/registro/gestante")
async def registrar_gestante(gestante_dto: GestanteDTO):
    gestante = gestante_dto.para_entidade()
    resposta = await autenticacao.registrar_usuario(gestante)
    return JSONResponse(status_code=200, content={"Response": resposta})


@router.post("/registro/profissional")
async def registrar_profissional(profissional_dto: ProfissionalDTO):
    profissional = profissional_dto.para_entidade()
    resposta = await autenticacao.registrar_usuario(profissional)
    return JSONResponse(status_code=200, content={"Response": resposta})


@router.post("/login")
async def login(usuario: RequisicaoLogin):
    try:
        resultado = await autenticacao.login(usuario)
        return resultado
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))


@router.get("/perfil")
async def perfil(current_user: dict = Depends(perfil_autorizado(["gestante"]))):
    return {"email": current_user.get("email"), "perfil": current_user.get("perfil"), "nome": current_user.get("nome")}

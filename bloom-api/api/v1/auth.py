from auth.AuthService import autenticacao
from controllers.dto.UsuarioDTO import UsuarioDTO
from domain.entities.entidade_usuario import Usuario
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import JSONResponse

from ..middlewares.CurrentUser import get_current_user, perfil_autorizado

router = APIRouter()


@router.post("/registro")
async def registrar(usuario: UsuarioDTO):
    usuario = Usuario(email=usuario.email, senha=usuario.senha, perfil=usuario.perfil)
    resposta = await autenticacao.registrar_usuario(usuario)
    return JSONResponse(status_code=200, content={"Response": resposta})


@router.post("/login")
async def login(usuario_input: Usuario):
    try:
        resultado = await autenticacao.login(usuario_input)
        return resultado
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))


@router.get("/perfil")
async def perfil(current_user: dict = Depends(perfil_autorizado(["gestante"]))):
    return {"email": current_user.get("email"), "perfil": current_user.get("perfil")}

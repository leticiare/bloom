from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse

from ..middlewares.CurrentUser import perfil_autorizado

router = APIRouter()


@router.post("/registrar")
async def registrar(current_user: dict = Depends(perfil_autorizado(["medico"]))):
    return JSONResponse(status_code=200, content={"Response": "<resposta>"})


@router.post("/editar")
async def editar(current_user: dict = Depends(perfil_autorizado(["medico"]))):
    return JSONResponse(status_code=200, content={"Response": "<resposta>"})


@router.post("/consultar")
async def consultar(
    current_user: dict = Depends(perfil_autorizado(["medico", "gestante"])),
):
    return JSONResponse(status_code=200, content={"Response": "<resposta>"})

from fastapi import APIRouter, Depends
from typing import List

from fastapi.responses import JSONResponse

from api.middlewares.CurrentUser import perfil_autorizado
from api.resposta_padrao import RespostaPadrao
from controllers.dto.ItemPlanoPreNatalDTO import ItemPlanoPreNatalDTO
from infra.repositories.RepositorioPlanoPreNatal import RepositorioPlanoPreNatal

router = APIRouter()


@router.get("/", response_model=RespostaPadrao[List[ItemPlanoPreNatalDTO]])
def obter_plano(usuario: dict = Depends(perfil_autorizado(["gestante"]))):
    plano = RepositorioPlanoPreNatal().obter_plano()
    return JSONResponse(
        content=[ItemPlanoPreNatalDTO.criar(item).para_dicionario() for item in plano],
        status_code=200,
    )

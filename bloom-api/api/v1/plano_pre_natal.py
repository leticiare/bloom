from fastapi import APIRouter, Depends
from typing import List

from api.middlewares.CurrentUser import perfil_autorizado
from api.resposta_padrao import RespostaPadrao
from domain.entities.PlanoPreNatal import ItemPlanoPreNatal
from infra.repositories.RepositorioPlanoPreNatal import RepositorioPlanoPreNatal

router = APIRouter()


@router.get("/", response_model=RespostaPadrao[List[ItemPlanoPreNatal]])
def obter_plano(usuario: dict = Depends(perfil_autorizado(["gestante"]))):
    return RepositorioPlanoPreNatal().obter_plano()

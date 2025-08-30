from auth.AuthService import ServicoAutenticacao
from dotenv import load_dotenv
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError

security = HTTPBearer()

load_dotenv(override=True)


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        ServicoAutenticacao.decodificar_token(credentials.token)
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido ou expirado",
            headers={"WWW-Authenticate": "Bearer"},
        )


def perfil_autorizado(allowed_roles: list[str]):
    def wrapper(current_user: dict = Depends(get_current_user)):
        if current_user.get("perfil") not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Você não tem permissão para acessar esta rota",
            )
        return current_user

    return wrapper

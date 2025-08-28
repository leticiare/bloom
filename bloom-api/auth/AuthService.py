import os
from datetime import datetime, timedelta
from typing import Optional

from domain.entities.Usuario import Usuario
from fastapi.security import OAuth2PasswordBearer
from infra.logger.logger import logger
from infra.repositories.RepositorioUsuario import RepositorioUsuario
from jose import JWTError, jwt
from passlib.context import CryptContext
from controllers.ControladorUsuario import ControladorUsuario


class ServicoAutenticacao:
    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
    SECRET_KEY = os.getenv("SECRET_KEY")
    ALGORITHM = os.getenv("ALGORITHM")
    ACCESS_EXPIRES = os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES") or 30

    @classmethod
    def _verificar_senha(cls, senha_entrada: str, hash_senha: str) -> bool:
        return cls.pwd_context.verify(senha_entrada, hash_senha)

    @classmethod
    def _obter_hash_senha(cls, senha: str) -> str:
        return cls.pwd_context.hash(senha)

    @classmethod
    def _gerar_token_acesso(
        cls,
        data: dict,
        expires_delta: Optional[timedelta] = timedelta(int(ACCESS_EXPIRES)),
    ):
        to_encode = data.copy()
        if expires_delta:
            expire = datetime.utcnow() + expires_delta
        else:
            expire = datetime.utcnow() + timedelta(minutes=30)
        to_encode.update({"exp": expire})
        return jwt.encode(to_encode, cls.SECRET_KEY, algorithm=cls.ALGORITHM)

    @classmethod
    def decodificar_token(cls, token: str) -> Optional[dict]:
        try:
            payload = jwt.decode(token, cls.SECRET_KEY, algorithms=[cls.ALGORITHM])
            return payload
        except JWTError:
            return None

    @classmethod
    async def registrar_usuario(cls, usuario: Usuario):
        hash_senha = cls._obter_hash_senha(usuario.senha)
        usuario.senha = hash_senha
        await ControladorUsuario().salvar(usuario)
        return {"msg": "Usuário criado com sucesso"}

    @classmethod
    async def login(cls, usuario: Usuario):
        usuario_encontrado: Usuario = (
            await RepositorioUsuario().buscar_usuario_por_email(usuario.email)
        )

        if not usuario_encontrado or not cls._verificar_senha(
            usuario.senha, usuario_encontrado.senha
        ):
            raise ValueError("Usuário ou senha incorretos")

        dados_usuario = {"email": usuario.email, "perfil": usuario.perfil}
        token = cls._gerar_token_acesso(dados_usuario)
        return {"jwt_token": token}


autenticacao = ServicoAutenticacao()

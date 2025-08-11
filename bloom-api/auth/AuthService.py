import os
from datetime import datetime, timedelta
from typing import Optional

from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext


class ServicoAutenticacao:
    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
    SECRET_KEY = os.getenv("SECRET_KEY")
    ALGORITHM = os.getenv("ALGORITHM")

    @classmethod
    def _verificar_senha(cls, senha_entrada: str, hash_senha: str) -> bool:
        return cls.pwd_context.verify(senha_entrada, hash_senha)

    @classmethod
    def obter_hash_senha(cls, senha: str) -> str:
        return cls.pwd_context.hash(senha)

    @classmethod
    def _gerar_token_acesso(cls, data: dict, expires_delta: Optional[timedelta] = None):
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


autenticacao = ServicoAutenticacao()

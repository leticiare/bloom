import os
from datetime import date, datetime, timedelta
from typing import Optional

from controllers.ControladorUsuario import ControladorUsuario
from domain.entities.Usuario import Usuario
from fastapi.security import OAuth2PasswordBearer
from infra.repositories.RepositorioUsuario import RepositorioUsuario
from jose import JWTError, jwt
from passlib.context import CryptContext
from infra.logger.logger import logger


class ServicoAutenticacao:
    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
    SECRET_KEY = os.getenv("SECRET_KEY")
    # Se a variável de ambiente vier como 'SHA256' (errado para jose),
    # mapeamos para um algoritmo JWT válido ('HS256'). Se não definida,
    # usamos um padrão seguro 'HS256'.
    _raw_algorithm = os.getenv("ALGORITHM")
    if _raw_algorithm:
        _alg_up = _raw_algorithm.strip().upper()
        if _alg_up in ("SHA256", "SHA-256"):
            ALGORITHM = "HS256"
            logger.warning(
                "Variável ALGORITHM contém '%s' — mapeando para '%s'",
                _raw_algorithm,
                ALGORITHM,
            )
        else:
            ALGORITHM = _raw_algorithm
    else:
        ALGORITHM = "HS256"
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
        for key, value in to_encode.items():
            if key != "exp" and isinstance(value, (datetime, date)):
                to_encode[key] = value.isoformat()
        try:
            return jwt.encode(to_encode, cls.SECRET_KEY, algorithm=cls.ALGORITHM)
        except Exception as e:
            # Log mais detalhado antes de propagar
            logger.error(
                "Falha ao gerar token JWT com algoritmo '%s': %s",
                cls.ALGORITHM,
                str(e),
            )
            raise

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

        dados_usuario = {
            "email": usuario.email,
            "perfil": usuario_encontrado.perfil,
            "id_entidade_perfil": usuario_encontrado.id_entidade_perfil,
        }
        token = cls._gerar_token_acesso(dados_usuario)
        return {"jwt_token": token}


autenticacao = ServicoAutenticacao()

import re
from datetime import datetime

from domain.enums.TiposDocumento import TiposDocumento
from domain.enums.UsuarioPerfil import UsuarioPerfil
from pydantic import BaseModel, EmailStr, validator


class UsuarioDTO(BaseModel):
    email: EmailStr
    senha: str
    perfil: UsuarioPerfil
    data_nascimento: datetime
    documento: str
    tipo_documento: TiposDocumento

    @validator("senha")
    def senha_segura(cls, v: str) -> str:
        if len(v) < 6:
            raise ValueError("A senha deve ter pelo menos 6 caracteres.")
        if not re.search(r"[A-Z]", v):
            raise ValueError("A senha deve conter pelo menos uma letra maiúscula.")
        if not re.search(r"[a-z]", v):
            raise ValueError("A senha deve conter pelo menos uma letra minúscula.")
        if not re.search(r"[0-9]", v):
            raise ValueError("A senha deve conter pelo menos um número.")
        return v

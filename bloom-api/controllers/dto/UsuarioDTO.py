from pydantic import BaseModel, EmailStr, validator
from typing import Literal
import re


class UsuarioDTO(BaseModel):
    email: EmailStr
    senha: str
    perfil: Literal["gestante", "profissional"]

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

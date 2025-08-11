from typing import Literal

from pydantic import EmailStr


class Usuario:
    email: EmailStr
    senha: str
    perfil: Literal["gestante", "profissional"]

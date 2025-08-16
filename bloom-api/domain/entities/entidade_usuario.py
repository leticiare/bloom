from dataclasses import dataclass
from typing import Literal

from pydantic import EmailStr


@dataclass
class Usuario:
    email: EmailStr
    senha: str
    perfil: Literal["gestante", "profissional"]

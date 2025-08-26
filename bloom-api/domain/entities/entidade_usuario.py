from dataclasses import dataclass
from datetime import datetime
from typing import Literal

from pydantic import EmailStr

from domain.contracts.Documento import Documento
from domain.enums.TiposDocumento import TiposDocumento


@dataclass
class Usuario:
    email: EmailStr
    senha: str
    perfil: Literal["gestante", "profissional"]
    documento: Documento
    tipo_documento: TiposDocumento
    data_nascimento: datetime

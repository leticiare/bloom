import datetime
from dataclasses import dataclass

from pydantic import EmailStr

from domain.contracts.Documento import Documento
from domain.enums.TiposDocumento import TiposDocumento
from domain.enums.UsuarioPerfil import UsuarioPerfil


@dataclass
class Usuario:
    email: EmailStr
    senha: str
    perfil: UsuarioPerfil
    data_nascimento: datetime
    tipo_documento: TiposDocumento
    documento: Documento

import uuid
from dataclasses import dataclass
from datetime import date
from typing import Optional

from domain.contracts.Documento import Documento
from domain.entities.Usuario import Usuario
from domain.enums.TiposDocumento import TiposDocumento
from domain.enums.UsuarioPerfil import UsuarioPerfil


@dataclass
class Gestante(Usuario):
    def __init__(
        self,
        email: str,
        nome: str,
        documento: Documento,
        tipo_documento: TiposDocumento,
        perfil: UsuarioPerfil,
        data_nascimento: date,
        dum: date,
        dpp: date,
        antecedentes_familiares: Optional[str] = None,
        antecedentes_ginecologicos: Optional[str] = None,
        antecedentes_obstetricos: Optional[str] = None,
        id: Optional[uuid.UUID] = None,
        senha: Optional[str] = None,
    ):
        super().__init__(
            email=email,
            senha=senha,
            documento=documento,
            perfil=perfil,
            tipo_documento=tipo_documento,
            data_nascimento=data_nascimento,
            id_entidade_perfil=id or uuid.uuid4(),
        )
        self.id = self.id_entidade_perfil
        self.nome = nome
        self.dum = dum
        self.dpp = dpp
        self.perfil = perfil
        self.antecedentes_familiares = antecedentes_familiares
        self.antecedentes_ginecologicos = antecedentes_ginecologicos
        self.antecedentes_obstetricos = antecedentes_obstetricos

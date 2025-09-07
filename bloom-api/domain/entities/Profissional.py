import uuid
from datetime import date
from typing import Optional

from domain.contracts.Documento import Documento
from domain.entities.Usuario import Usuario
from domain.enums.EspecialidadesMedicas import EspecialidadesMedicas
from domain.enums.TiposDocumento import TiposDocumento
from domain.enums.UsuarioPerfil import UsuarioPerfil


class Profissional(Usuario):
    """
    Representa um profissional de saúde no sistema.
    Herdado de Usuario, adiciona campos específicos de profissional.
    """

    def __init__(
        self,
        email: str,
        senha: str,
        documento: Documento,
        tipo_documento: TiposDocumento,
        data_nascimento: date,
        nome: str,
        especialidade: EspecialidadesMedicas,
        registro: str,
        codigo: Optional[uuid.UUID] = None,
        criado_em: Optional[date] = None,
        atualizado_em: Optional[date] = None,
        perfil: UsuarioPerfil = UsuarioPerfil.PROFISSIONAL,
    ):
        super().__init__(
            email=email,
            senha=senha,
            documento=documento,
            tipo_documento=tipo_documento,
            data_nascimento=data_nascimento,
            perfil=perfil,
            id_entidade_perfil=codigo,
        )
        self.codigo = codigo
        self.nome = nome
        self.especialidade = especialidade
        self.usuario_email = email
        self.registro = registro

from domain.entities.Profissional import Profissional
from domain.enums.EspecialidadesMedicas import EspecialidadesMedicas
from domain.enums.UsuarioPerfil import UsuarioPerfil

from .UsuarioDTO import UsuarioDTO


class ProfissionalDTO(UsuarioDTO):
    perfil: UsuarioPerfil = UsuarioPerfil.PROFISSIONAL
    nome: str
    especialidade: EspecialidadesMedicas
    registro: str

    def para_entidade(self) -> Profissional:
        return Profissional(
            email=self.email,
            senha=self.senha,
            documento=self.documento,
            tipo_documento=self.tipo_documento,
            data_nascimento=self.data_nascimento,
            nome=self.nome,
            especialidade=self.especialidade,
            registro=self.registro,
        )

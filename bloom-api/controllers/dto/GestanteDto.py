from datetime import date
from typing import Optional

from domain.entities.Gestante import Gestante
from domain.enums.UsuarioPerfil import UsuarioPerfil
from domain.factories.FabricaDocumento import FabricaDocumento

from .UsuarioDTO import UsuarioDTO


class GestanteDTO(UsuarioDTO):
    perfil: UsuarioPerfil = UsuarioPerfil.GESTANTE
    nome: str
    dum: date
    dpp: Optional[date] = None
    antecedentes_familiares: Optional[str] = None
    antecedentes_ginecologicos: Optional[str] = None
    antecedentes_obstetricos: Optional[str] = None

    def para_entidade(self) -> Gestante:
        return Gestante(
            email=self.email,
            senha=self.senha,
            documento=FabricaDocumento.criar_documento(
                self.tipo_documento, self.documento
            ).obter_numero(),
            perfil=self.perfil,
            tipo_documento=self.tipo_documento,
            data_nascimento=self.data_nascimento,
            nome=self.nome,
            dum=self.dum,
            dpp=self.dpp,
            antecedentes_familiares=self.antecedentes_familiares,
            antecedentes_ginecologicos=self.antecedentes_ginecologicos,
            antecedentes_obstetricos=self.antecedentes_obstetricos,
        )

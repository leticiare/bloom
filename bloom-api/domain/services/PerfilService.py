from controllers.ControladorGestante import ControladorGestante
from controllers.ControladorProfissional import ControladorProfissional
from domain.enums.UsuarioPerfil import UsuarioPerfil


class PerfilService:
    def __init__(self):
        self._controlador_gestante = ControladorGestante()
        self._controlador_profissional = ControladorProfissional()

    async def obter_por_perfil(self, perfil: str, email: str):
        perfil = perfil.upper()
        if perfil == UsuarioPerfil.PROFISSIONAL.value:
            return await self._controlador_profissional.obter_profissional_por_email(
                email=email
            )
        if perfil == UsuarioPerfil.GESTANTE.value:
            return await self._controlador_gestante.obter_gestante_por_email(
                email=email
            )

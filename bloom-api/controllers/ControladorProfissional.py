from infra.repositories.RepositorioProfissional import RepositorioProfissional


class ControladorProfissional:
    def __init__(self):
        self._repositorio: RepositorioProfissional = RepositorioProfissional()

    async def obter_profissional_por_email(self, email: str):
        return await self._repositorio.buscar_profissional_por_email(email=email)

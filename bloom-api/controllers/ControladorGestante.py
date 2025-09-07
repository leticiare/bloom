from infra.repositories.RepositorioGestante import RepositorioGestante


class ControladorGestante:
    def __init__(self):
        self._repositorio: RepositorioGestante = RepositorioGestante()

    def obter_gestante_por_id(self, id: str):
        return self._repositorio.buscar_gestante_por_id(id)

    async def obter_gestante_por_email(self, email: str):
        return await self._repositorio.buscar_gestante_por_email(email=email)

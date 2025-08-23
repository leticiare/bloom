from infra.repositories.repositorio_usuario import RepositorioUsuario


class ControladorUsuario:
    def __init__(self):
        self._repositorio: RepositorioUsuario = RepositorioUsuario()

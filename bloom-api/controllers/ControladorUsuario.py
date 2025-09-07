import asyncio

from domain.entities.Gestante import Gestante
from domain.entities.Profissional import Profissional
from domain.entities.Usuario import Usuario
from infra.db.conexao import ConexaoBancoDados
from infra.repositories.RepositorioGestante import RepositorioGestante
from infra.repositories.RepositorioProfissional import RepositorioProfissional
from infra.repositories.RepositorioUsuario import RepositorioUsuario


def run_async_in_thread(coro):
    return asyncio.run(coro)


class ControladorUsuario:
    def __init__(self):
        self._repositorio_profissional = RepositorioProfissional()
        self._repositorio_usuario = RepositorioUsuario()
        self._repositorio_gestante = RepositorioGestante()

    async def salvar(self, usuario: Usuario):
        db = ConexaoBancoDados.obter_instancia()

        async with db.transacao():
            usuario.perfil = usuario.perfil.value.lower()
            usuario.tipo_documento = usuario.tipo_documento.value

            if isinstance(usuario, Profissional):
                usuario.id_entidade_perfil = usuario.codigo
            elif isinstance(usuario, Gestante):
                usuario.id_entidade_perfil = usuario.id

            await asyncio.to_thread(
                run_async_in_thread, self._repositorio_usuario.inserir_usuario(usuario)
            )

            if isinstance(usuario, Profissional):
                usuario.especialidade = usuario.especialidade.value
                await asyncio.to_thread(
                    run_async_in_thread,
                    self._repositorio_profissional.criar_profissional(usuario),
                )
            elif isinstance(usuario, Gestante):
                await asyncio.to_thread(
                    run_async_in_thread,
                    self._repositorio_gestante.criar_gestante(usuario),
                )
            else:
                raise TypeError("Tipo de usuário não suportado")

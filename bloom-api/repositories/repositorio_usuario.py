from domain.entities.entidade_usuario import Usuario
from infra.db.iniciar_db import conexao


class RepositorioUsuario:
    @staticmethod
    async def buscar_usuario_por_email(email: str) -> Usuario:
        resultado = await conexao.executar_sql(
            f"SELECT * FROM usuarios WHERE email = '{email}'"
        )

        if not resultado:
            return None

        usuario = Usuario(
            email=resultado["email"],
            senha=resultado["senha"],
            perfil=resultado["perfil"],
        )
        return usuario

    @staticmethod
    async def inserir_usuario(usuario: Usuario):
        query = f"""
        INSERT INTO usuarios (email, senha, perfil)
        VALUES ('{usuario.email}', '{usuario.senha}', '{usuario.perfil}')
        """
        await conexao.executar_sql(query)


repositorio_usuario = RepositorioUsuario()

import os

from domain.entities.entidade_usuario import Usuario
from dotenv import load_dotenv

from infra.db.conexao import ConexaoBancoDados
from infra.db.iniciar_db import conexao
from infra.logger.logger import logger

load_dotenv()


class RepositorioUsuario:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "usuario"
        self._schema: str = os.getenv("SCHEMA_DB")

    async def buscar_usuario_por_email(self, email: str) -> Usuario:
        try:
            resultado = conexao.executar_sql(
                f"SELECT * FROM bloom_db.{self._tabela} WHERE email = '{email}'", True
            )[0]
            logger.debug(f"BUSCA: {resultado}")
            if not resultado:
                return None

            usuario = Usuario(
                email=resultado[0], senha=resultado[1], perfil=resultado[4]
            )
            return usuario
        except Exception as e:
            logger.info(f"Erro ao reciperar usuario: {e}")
            raise e

    async def inserir_usuario(self, usuario: Usuario):
        try:
            query = f"""
            INSERT INTO bloom_db.{self._tabela} (email, senha, perfil)
            VALUES ('{usuario.email}', '{usuario.senha}', '{usuario.perfil}')
            """
            self._conexao.executar_sql(query)
        except Exception as e:
            logger.info(f"Erro ao cadastrar usuario: {e}")
            raise e


repositorio_usuario = RepositorioUsuario()

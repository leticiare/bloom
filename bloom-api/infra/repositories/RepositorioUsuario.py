from domain.entities.Usuario import Usuario
from dotenv import load_dotenv
from psycopg2.sql import SQL, Identifier

from infra.db.conexao import ConexaoBancoDados
from infra.db.iniciar_db import conexao
from infra.logger.logger import logger

load_dotenv()


class RepositorioUsuario:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "usuario"

    async def buscar_usuario_por_email(self, email: str) -> Usuario:
        try:
            sql = SQL("""
                    SELECT * FROM {tabela} WHERE email = %s
                """).format(tabela=Identifier(self._tabela))
            resultado = conexao.executar_sql(
                sql=sql, parametros=(email,), possui_resultado=True
            )[0]

            if not resultado:
                return None

            usuario = Usuario(
                email=resultado[0],
                senha=resultado[1],
                perfil=resultado[4],
                data_nascimento=resultado[4],
                tipo_documento=resultado[5],
                documento=resultado[6],
            )
            return usuario
        except Exception as e:
            logger.error(f"Erro ao recuperar usuario: {e}")
            raise e

    async def inserir_usuario(self, usuario: Usuario):
        try:
            sql = SQL("""
                  INSERT INTO {tabela} (email, senha, perfil) VALUES (%s, %s, %s)
                """).format(tabela=Identifier(self._tabela))

            self._conexao.executar_sql(
                sql=sql, parametros=(usuario.email, usuario.senha, usuario.perfil)
            )
        except Exception as e:
            logger.error(f"Erro ao cadastrar usuario: {e}")
            raise e


repositorio_usuario = RepositorioUsuario()

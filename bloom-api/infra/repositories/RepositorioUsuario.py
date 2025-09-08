from domain.entities.Usuario import Usuario
from dotenv import load_dotenv
from psycopg2.sql import SQL, Identifier

from domain.factories.FabricaDocumento import TiposDocumento
from domain.factories import FabricaDocumento

from infra.db.conexao import ConexaoBancoDados
from infra.db.iniciar_db import conexao
from infra.logger.logger import logger
from domain.factories.FabricaDocumento import FabricaDocumento
from domain.enums.TiposDocumento import TiposDocumento

load_dotenv()


class RepositorioUsuario:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "usuario"

    async def buscar_usuario_por_email(self, email: str) -> Usuario:
        try:
            sql = SQL("""
                    SELECT email, senha, perfil, data_nascimento, tipo_documento, documento, id_entidade_perfil FROM {tabela} WHERE email = %s
                """).format(tabela=Identifier(self._tabela))
            resultado = conexao.executar_sql(
                sql=sql, parametros=(email,), possui_resultado=True
            )

            if not resultado:
                return None

            resultado = resultado[0]

            tipo_documento = TiposDocumento(resultado[4])
            documento = FabricaDocumento.criar_documento(tipo_documento, resultado[5])
            usuario = Usuario(
                email=resultado[0],
                senha=resultado[1],
                perfil=resultado[2],
                data_nascimento=resultado[3],
                tipo_documento=tipo_documento,
                documento=documento,
                id_entidade_perfil=resultado[6],
            )
            return usuario
        except Exception as e:
            logger.error(f"Erro ao recuperar usuario: {e}")
            raise e

    async def inserir_usuario(self, usuario: Usuario):
        try:
            sql = SQL("""
                  INSERT INTO {tabela} (email, senha, perfil, documento, tipo_documento, data_nascimento, id_entidade_perfil) VALUES (%s, %s, %s,%s,%s,%s,%s)
                """).format(tabela=Identifier(self._tabela))

            self._conexao.executar_sql(
                sql=sql,
                parametros=(
                    usuario.email,
                    usuario.senha,
                    usuario.perfil,
                    usuario.documento,
                    usuario.tipo_documento.value,
                    usuario.data_nascimento,
                    str(usuario.id_entidade_perfil),
                ),
            )
        except Exception as e:
            logger.error(f"Erro ao cadastrar usuario: {e}")
            raise e


repositorio_usuario = RepositorioUsuario()

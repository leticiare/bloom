# TODO: inserir() atualizar() obterPorId() obterTodos()
from domain.entities.Artigo import Artigo
from psycopg2.sql import SQL, Identifier

from infra.db.conexao import ConexaoBancoDados


class RepositorioArtigo:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "artigo"

    def inserir(self, artigo: Artigo, usuario_email: str):
        sql = SQL("""
                  INSERT INTO {tabela} (titulo, conteudo, temas, usuario_email) VALUES (%s, %s, %s, %s, )
                """).format(tabela=Identifier(self._tabela))

        self._conexao.executar_sql(
            sql=sql,
            parametros=(artigo.titulo, artigo.conteudo, artigo.temas, usuario_email),
        )

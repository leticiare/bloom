# TODO: inserir() atualizar() obterPorId() obterTodos()
from domain.entities.Artigo import Artigo
from psycopg2.sql import SQL, Identifier

from infra.db.conexao import ConexaoBancoDados


class RepositorioArtigo:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "artigo"

    def inserir(self, artigo: Artigo):
        sql = SQL("""
                  INSERT INTO {tabela} (id, titulo, conteudo, temas, usuario_email) VALUES (%s, %s, %s, %s, %s)
                """).format(tabela=Identifier(self._tabela))

        self._conexao.executar_sql(
            sql=sql,
            parametros=(
                artigo.id,
                artigo.titulo,
                artigo.conteudo,
                artigo.temas,
                artigo.autor,
            ),
        )

    def excluir(self, id_artigo: str) -> None:
        sql = SQL("""
            DELETE FROM {tabela}
            WHERE id = %s
        """).format(tabela=Identifier(self._tabela))

        self._conexao.executar_sql(sql=sql, parametros=(id_artigo,))

    def obter_por_id(self, id_artigo: str) -> Artigo | None:
        sql = SQL("""
            SELECT id, titulo, conteudo, temas, usuario_email
            FROM {tabela}
            WHERE id = %s
        """).format(tabela=Identifier(self._tabela))

        registro = self._conexao.executar_sql(
            sql=sql, parametros=(id_artigo,), possui_resultado=True
        )[0]

        if not registro:
            return None

        return Artigo(
            id=registro[0],
            titulo=registro[1],
            conteudo=registro[2],
            temas=registro[3],
            autor=registro[4],
        )

    def editar(self, artigo: Artigo) -> None:
        sql = SQL("""
            UPDATE {tabela}
            SET titulo = %s,
                conteudo = %s,
                temas = %s,
                usuario_email = %s
            WHERE id = %s
        """).format(tabela=Identifier(self._tabela))

        self._conexao.executar_sql(
            sql=sql,
            parametros=(
                artigo.titulo,
                artigo.conteudo,
                artigo.temas,
                artigo.autor,
                artigo.id,
            ),
        )

    def obter_todos(self) -> list[Artigo]:
        sql = SQL("""
            SELECT id, titulo, conteudo, temas, usuario_email
            FROM {tabela}
        """).format(tabela=Identifier(self._tabela))

        registros = self._conexao.executar_sql(sql=sql, possui_resultado=True)

        artigos: list[Artigo] = []
        for registro in registros:
            artigos.append(
                Artigo(
                    id=registro[0],
                    titulo=registro[1],
                    conteudo=registro[2],
                    temas=registro[3],
                    autor=registro[4],
                )
            )

        return artigos

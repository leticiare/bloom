from domain.entities.Exame import Exame
from infra.db.conexao import ConexaoBancoDados
from psycopg2.sql import SQL, Identifier


class RepositorioExame:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "agenda"

    def inserir(self, exame: Exame):
        try:
            sql = SQL("""
                    INSERT INTO {tabela} (id, status, data_agendamento, data_realizacao, item_plano_pre_natal_id, tipo)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """).format(tabela=Identifier(self._tabela))

            self._conexao.executar_sql(
                sql=sql,
                parametros=(
                    exame.id,
                    exame.status.value,
                    exame.data_agendamento,
                    exame.data_realizacao,
                    exame.info_plano.id,
                    exame.tipo,
                ),
            )
        except Exception as e:
            print(f"Erro ao inserir exame: {e}")
            raise e

    def atualizar(self, exame: Exame):
        try:
            sql = SQL("""
                UPDATE {tabela}
                SET status = %s, data_agendamento = %s, data_realizacao = %s, item_plano_pre_natal_id = %s, tipo = %s
                WHERE id = %s
            """).format(tabela=Identifier(self._tabela))

            self._conexao.executar_sql(
                sql=sql,
                parametros=(
                    exame.status.value,
                    exame.data_agendamento,
                    exame.data_realizacao,
                    exame.info_plano.id,
                    exame.tipo,
                    exame.id,
                ),
            )
        except Exception as e:
            print(f"Erro ao atualizar exame: {e}")
            raise e

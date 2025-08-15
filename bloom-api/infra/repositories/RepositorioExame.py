from domain.entities.Exame import Exame
from domain.entities.PlanoPreNatal import ItemPlanoPreNatal
from infra.db.conexao import ConexaoBancoDados
from infra.schemas.PlanoPreNatalSchema import PlanoPreNatalSchema
from infra.schemas.AgendaSchema import AgendaSchema
from psycopg2.sql import SQL, Identifier


class RepositorioExame:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "agenda"

    def _mapear_para_entidade(self, linha_db) -> Exame:
        info_plano = ItemPlanoPreNatal(
            id=linha_db[4],
            nome=linha_db[5],
            descricao=linha_db[6],
            semana_inicio=linha_db[7],
            semana_fim=linha_db[8],
        )

        return Exame(
            id=linha_db[0],
            status=linha_db[1],
            data_agendamento=linha_db[2],
            data_realizacao=linha_db[3],
            info_plano=info_plano,
        )

    def _obter_sql_busca(self) -> str:
        colunas_select = ", ".join(
            [
                AgendaSchema.ID,
                AgendaSchema.STATUS,
                AgendaSchema.DATA_AGENDAMENTO,
                AgendaSchema.DATA_REALIZACAO,
                PlanoPreNatalSchema.ID,
                PlanoPreNatalSchema.NOME,
                PlanoPreNatalSchema.DESCRICAO,
                PlanoPreNatalSchema.SEMANA_INICIO,
                PlanoPreNatalSchema.SEMANA_FIM,
            ]
        )
        return f"""
            SELECT {colunas_select} FROM {self._tabela}
            JOIN plano_pre_natal ON agenda.item_plano_pre_natal_id = plano_pre_natal.id
        """

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

    def obter_todos_por_gestante(self, gestante_id: str):
        sql = f"""
            {self._obter_sql_busca()}
            WHERE agenda.gestante_id = '{gestante_id}'
        """
        resultado = self._conexao.executar_sql(sql, possui_resultado=True)

        if resultado:
            return [self._mapear_para_entidade(item) for item in resultado]

        else:
            return []

    def obter_por_id(self, id: str):
        try:
            sql = f"""
                {self._obter_sql_busca()}
                WHERE {self._tabela}.id = '{id}'
            """
            resultado = self._conexao.executar_sql(sql, possui_resultado=True)

            if resultado:
                return self._mapear_para_entidade(resultado[0])

            else:
                return None

        except Exception as e:
            print(f"Erro ao obter exames por item de plano pré-natal: {e}")
            raise e

from domain.factories.FabricaEventoAgenda import FabricaEventoAgenda
from domain.entities.EventoAgenda import EventoAgenda, TipoEventoAgenda
from infra.db.conexao import ConexaoBancoDados
from infra.schemas.PlanoPreNatalSchema import PlanoPreNatalSchema
from infra.schemas.AgendaSchema import AgendaSchema
from psycopg2.sql import SQL, Identifier


class RepositorioEventoAgenda:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "agenda"

    def _mapear_para_entidade(self, linha_db) -> EventoAgenda:
        info_plano = None
        if len(linha_db) > 6:
            info_plano = {
                "id": linha_db[6],
                "nome": linha_db[7],
                "descricao": linha_db[8],
                "semana_inicio": linha_db[9],
                "semana_fim": linha_db[10],
            }

        dados_entidade = {
            "id": linha_db[0],
            "status": linha_db[1],
            "data_agendamento": linha_db[2],
            "data_realizacao": linha_db[3],
            "observacoes": linha_db[4],
            "tipo": linha_db[5],
            "info_plano": info_plano,
        }

        entidade = FabricaEventoAgenda.criar_evento_agenda(dados=dados_entidade)
        return entidade

    def _obter_sql_busca(self) -> str:
        colunas_select = ", ".join(
            [
                "agenda." + AgendaSchema.ID,
                "agenda." + AgendaSchema.STATUS,
                "agenda." + AgendaSchema.DATA_AGENDAMENTO,
                "agenda." + AgendaSchema.DATA_REALIZACAO,
                "agenda." + AgendaSchema.OBSERVACOES,
                "agenda." + AgendaSchema.TIPO,
                "plano_pre_natal." + PlanoPreNatalSchema.ID,
                "plano_pre_natal." + PlanoPreNatalSchema.NOME,
                "plano_pre_natal." + PlanoPreNatalSchema.DESCRICAO,
                "plano_pre_natal." + PlanoPreNatalSchema.SEMANA_INICIO,
                "plano_pre_natal." + PlanoPreNatalSchema.SEMANA_FIM,
            ]
        )
        return f"""
            SELECT {colunas_select} FROM {self._tabela}
            JOIN plano_pre_natal ON agenda.item_plano_pre_natal_id = plano_pre_natal.id
        """

    def inserir(self, evento: EventoAgenda):
        try:
            sql = SQL("""
                    INSERT INTO {tabela} (id, status, data_agendamento, data_realizacao, item_plano_pre_natal_id, tipo)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """).format(tabela=Identifier(self._tabela))

            self._conexao.executar_sql(
                sql=sql,
                parametros=(
                    evento.id,
                    evento.status.value,
                    evento.data_agendamento,
                    evento.data_realizacao,
                    evento.info_plano.id,
                    evento.tipo,
                ),
            )
        except Exception as e:
            print(f"Erro ao inserir evento: {e}")
            raise e

    def atualizar(self, evento: EventoAgenda):
        try:
            sql = SQL("""
                UPDATE {tabela}
                SET status = %s, data_agendamento = %s, data_realizacao = %s, item_plano_pre_natal_id = %s, tipo = %s
                WHERE id = %s
            """).format(tabela=Identifier(self._tabela))

            self._conexao.executar_sql(
                sql=sql,
                parametros=(
                    evento.status.value,
                    evento.data_agendamento,
                    evento.data_realizacao,
                    evento.info_plano.id,
                    evento.tipo,
                    evento.id,
                ),
            )
        except Exception as e:
            print(f"Erro ao atualizar evento: {e}")
            raise e

    def obter_todos_por_gestante(self, gestante_id: str, tipo: TipoEventoAgenda):
        sql = f"""
            {self._obter_sql_busca()}
            WHERE agenda.gestante_id = '{gestante_id}' AND agenda.tipo = '{tipo.value}'
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
            print(f"Erro ao obter eventos por item de plano pré-natal: {e}")
            raise e

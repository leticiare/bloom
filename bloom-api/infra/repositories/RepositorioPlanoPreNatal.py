from domain.entities.PlanoPreNatal import ItemPlanoPreNatal
from infra.db.conexao import ConexaoBancoDados
from psycopg2.sql import SQL, Identifier
from infra.logger.logger import logger


class RepositorioPlanoPreNatal:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela_plano: str = "plano_pre_natal"
        self._tabela_agenda: str = "agenda"

    def _mapear_para_entidade(self, linha: tuple) -> ItemPlanoPreNatal:
        return ItemPlanoPreNatal(
            id=linha[0],
            nome=linha[1],
            descricao=linha[2],
            semana_inicio=linha[3],
            semana_fim=linha[4],
        )

    def obter_plano(self) -> list[ItemPlanoPreNatal]:
        try:
            sql = SQL(
                "SELECT id, nome, descricao, semana_inicio, semana_fim FROM {tabela}"
            ).format(tabela=Identifier(self._tabela_plano))
            resultado = self._conexao.executar_sql(sql=sql, possui_resultado=True)
            return [self._mapear_para_entidade(linha) for linha in resultado]
        except Exception as e:
            logger.error(f"Erro ao obter plano pré-natal: {e}")
            return []

    def criar_plano_para_gestante(self, gestante_id: str):
        try:
            # Para cada linha da tabela plano pré-natal, é criado um agendamento na tabela de agenda com o relacionamento para a gestante informada, de forma que todos os itens do plano possuam um agendamento relacionado, correspondendo ao plano específico da gestante
            sql = SQL("""
                INSERT INTO {tabela_agenda} (id, status, data_agendamento, data_realizacao, item_plano_pre_natal_id, tipo, gestante_id)
                SELECT gen_random_uuid(), 'pendente', NULL, NULL, pp.id, pp.tipo, %s
                FROM {tabela_plano} pp
            """).format(
                tabela_agenda=Identifier(self._tabela_agenda),
                tabela_plano=Identifier(self._tabela_plano),
            )
            self._conexao.executar_sql(sql=sql, parametros=(str(gestante_id),))
        except Exception as e:
            logger.error(f"Erro ao criar plano para gestante {gestante_id}: {e}")
            raise e

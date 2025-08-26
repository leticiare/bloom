import uuid

from domain.entities.Profissional import Profissional
from dotenv import load_dotenv
from psycopg2.sql import SQL, Identifier

from infra.db.conexao import ConexaoBancoDados
from infra.db.iniciar_db import conexao
from infra.logger.logger import logger

load_dotenv()


class RepositorioProfissional:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "profissional_saude"

    async def buscar_profissional_por_email(self, email: str) -> Profissional:
        sql = SQL("""
                    SELECT * FROM {tabela} WHERE email = %s
                """).format(tabela=Identifier(self._tabela))
        resultado = conexao.executar_sql(
            sql=sql, parametros=(email,), possui_resultado=True
        )[0]
        logger.debug(f"BUSCA: {resultado}")
        if not resultado:
            return None

        profissional = Profissional(
            email=resultado[0],
            senha=resultado[1],
            documento=resultado[4],
            data_nascimento=[],
        )
        return profissional

    async def criar_profissional(
        self,
        profissional: Profissional,
    ) -> Profissional:
        sql = SQL("""
                INSERT INTO {tabela} (codigo, nome, especialidade,registro, usuario_email)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING codigo, nome, especialidade, usuario_email;
            """).format(tabela=Identifier(self._tabela))

        codigo = str(uuid.uuid4())

        self._conexao.executar_sql(
            sql=sql,
            parametros=(
                codigo,
                profissional.nome,
                profissional.especialidade,
                profissional.registro,
                profissional.email,
            ),
        )

import uuid

from domain.entities.Profissional import Profissional
from dotenv import load_dotenv
from psycopg2.sql import SQL, Identifier
from domain.enums.TiposDocumento import TiposDocumento
from domain.factories.FabricaDocumento import FabricaDocumento
from domain.enums.UsuarioPerfil import UsuarioPerfil
from infra.db.conexao import ConexaoBancoDados
from infra.db.iniciar_db import conexao
from infra.logger.logger import logger

load_dotenv()


class RepositorioProfissional:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._tabela: str = "profissional_saude"
        self._tabela_usuario: str = "usuario"

    async def buscar_profissional_por_email(self, email: str) -> Profissional:
        sql = SQL("""
        SELECT
            p.codigo, p.nome, u.email, u.senha, u.perfil, u.data_nascimento,
            u.documento, u.tipo_documento, p.especialidade, p.registro
        FROM {tabela} p
        INNER JOIN {tabela_usuario} u ON p.usuario_email = u.email
        WHERE u.email = %s
    """).format(
            tabela=Identifier(self._tabela),
            tabela_usuario=Identifier(self._tabela_usuario),
        )
        resultado = conexao.executar_sql(
            sql=sql, parametros=(email,), possui_resultado=True
        )[0]
        logger.debug(f"BUSCA: {resultado}")
        if not resultado:
            return None

        profissional = Profissional(
            codigo=resultado[0],
            nome=resultado[1],
            email=resultado[2],
            senha=resultado[3],
            perfil=UsuarioPerfil(resultado[4].upper()),
            data_nascimento=resultado[5],
            documento=FabricaDocumento.criar_documento(resultado[7], resultado[6]),
            tipo_documento=TiposDocumento(resultado[7]),
            especialidade=resultado[8],
            registro=resultado[9],
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

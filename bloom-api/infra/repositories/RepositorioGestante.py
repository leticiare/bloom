import uuid

from domain.entities.Gestante import Gestante
from domain.enums.TiposDocumento import TiposDocumento
from domain.factories.FabricaDocumento import FabricaDocumento
from dotenv import load_dotenv
from psycopg2.sql import SQL, Identifier

from infra.db.conexao import ConexaoBancoDados
from infra.db.iniciar_db import conexao
from infra.repositories.RepositorioPlanoPreNatal import RepositorioPlanoPreNatal

load_dotenv()


class RepositorioGestante:
    def __init__(self):
        self._conexao: ConexaoBancoDados = ConexaoBancoDados.obter_instancia()
        self._repositorio_pre_natal: RepositorioPlanoPreNatal = (
            RepositorioPlanoPreNatal()
        )
        self._tabela: str = "gestante"
        self._tabela_usuario: str = "usuario"

    async def buscar_gestante_por_email(self, email: str) -> Gestante:
        sql = SQL("""
        SELECT
            g.id, g.nome, u.email, u.senha, u.perfil, u.data_nascimento,
            u.documento, u.tipo_documento, g.dum, g.dpp, g.antecedentes_familiares,
            g.antecedentes_ginecologicos, g.antecedentes_obstetricos
        FROM {tabela_gestante} g
        INNER JOIN {tabela_usuario} u ON g.usuario_email = u.email
        WHERE u.email = %s
    """).format(
            tabela_gestante=Identifier(self._tabela),
            tabela_usuario=Identifier(self._tabela_usuario),
        )
        resultado = conexao.executar_sql(
            sql=sql, parametros=(email,), possui_resultado=True
        )[0]

        if not resultado:
            return None

        gestante = Gestante(
            id=resultado[0],
            nome=resultado[1],
            email=resultado[2],
            senha=resultado[3],
            perfil=resultado[4],
            data_nascimento=resultado[5],
            documento=FabricaDocumento.criar_documento(resultado[7], resultado[6]),
            tipo_documento=TiposDocumento(resultado[7]),
            dum=resultado[8],
            dpp=resultado[9],
            antecedentes_familiares=resultado[10],
            antecedentes_ginecologicos=resultado[11],
            antecedentes_obstetricos=resultado[12],
        )
        return gestante

    async def criar_gestante(
        self,
        gestante: Gestante,
    ) -> Gestante:
        sql = SQL("""
                INSERT INTO {tabela} (
                    id, nome, dum, dpp,
                    antecedentes_familiares, antecedentes_ginecologicos,
                    antecedentes_obstetricos, usuario_email
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING id, nome, dum, dpp, usuario_email;
            """).format(tabela=Identifier(self._tabela))

        self._conexao.executar_sql(
            sql=sql,
            parametros=(
                str(gestante.id),
                gestante.nome,
                gestante.dum,
                gestante.dpp,
                gestante.antecedentes_familiares,
                gestante.antecedentes_ginecologicos,
                gestante.antecedentes_obstetricos,
                gestante.email,
            ),
        )

        self._repositorio_pre_natal.criar_plano_para_gestante(gestante.id)

        return gestante

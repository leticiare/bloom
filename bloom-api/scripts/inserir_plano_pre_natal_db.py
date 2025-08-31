import csv
import uuid
from psycopg2.sql import SQL, Identifier

import infra.db.iniciar_db
from infra.db.conexao import ConexaoBancoDados

caminho_arquivo = "data/plano_pre_natal.csv"

with open(caminho_arquivo, newline="", encoding="utf-8") as arquivo_csv:
    conexao = ConexaoBancoDados.obter_instancia()
    sql = SQL("""
        INSERT INTO {tabela} (id, nome, descricao, semana_inicio, semana_fim, tipo)
        VALUES (%s, %s, %s, %s, %s, %s)
    """).format(tabela=Identifier("plano_pre_natal"))

    leitor_csv = csv.DictReader(arquivo_csv)
    for linha in leitor_csv:
        id = str(uuid.uuid4())
        nome = linha["nome"]
        descricao = linha["descricao"]
        semana_inicio = linha["semana_inicio"]
        semana_fim = linha["semana_fim"]
        tipo = linha["tipo"]

        conexao.executar_sql(
            sql, (id, nome, descricao, semana_inicio, semana_fim, tipo)
        )

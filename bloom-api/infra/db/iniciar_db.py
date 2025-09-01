import os
from infra.db.conexao import ConexaoBancoDados
from dotenv import load_dotenv

load_dotenv(override=True)

conexao = ConexaoBancoDados.criar(
    nome_banco=os.getenv("NOME_BD") or "",
    usuario=os.getenv("USUARIO_BD") or "",
    senha=os.getenv("SENHA_BD") or "",
    host=os.getenv("HOST_BD") or "",
    schema=os.getenv("SCHEMA_DB") or "public",
)

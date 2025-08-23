from typing import List, Tuple, Union
import psycopg2
from psycopg2.sql import SQL, Composable


class ConexaoBancoDados:
    _instancia = None

    @classmethod
    def obter_instancia(cls):
        if cls._instancia is None:
            raise RuntimeError(
                "ConexaoBancoDados ainda não foi inicializado, utilize o método criar()."
            )
        return cls._instancia

    @classmethod
    def criar(cls, nome_banco: str, usuario: str, senha: str, host: str, schema: str):
        if cls._instancia is None:
            cls._instancia = super(ConexaoBancoDados, cls).__new__(cls)
            cls._instancia._iniciar_conexao(nome_banco, usuario, senha, host, schema)
        return cls._instancia

    def __new__(cls, *args, **kwargs):
        if cls._instancia is None:
            raise RuntimeError("Use criar() para criar a instância Singleton.")
        return cls._instancia

    def _iniciar_conexao(
        self, nome_banco: str, usuario: str, senha: str, host: str, schema: str
    ):
        self.conexao = psycopg2.connect(
            dbname=nome_banco,
            user=usuario,
            password=senha,
            host=host,
            options=f"-c search_path={schema}",
        )

    def executar_sql(self, sql: Union[str, SQL, Composable], parametros: Union[Tuple, List, None] = None, possui_resultado: bool = False) -> list | None:
        resultado = None

        try:
            cursor = self.conexao.cursor()
            cursor.execute(sql, parametros)
            if possui_resultado:
                resultado = cursor.fetchall()
            cursor.close()
            self.conexao.commit()
        except Exception as e:
            print(f"Erro ao executar query: {e}")
            self.conexao.rollback()
            raise e

        return resultado

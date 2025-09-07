from dataclasses import dataclass


@dataclass
class Artigo:
    def __init__(
        self,
        id: str,
        titulo: str,
        temas: list[str],
        conteudo: str,
        autor: str,
    ):
        self.id = id
        self.titulo = titulo
        self.temas = temas if isinstance(temas, list) else [temas]
        self.conteudo = conteudo
        self.autor = autor

    @property
    def titulo_contem_texto(self):
        return bool(self.titulo and self.titulo.strip())

    @property
    def conteudo_contem_texto(self):
        return bool(self.conteudo and self.conteudo.strip())

    @property
    def contem_tema(self):
        if len(self.temas) > 0:
            return True
        return False

    def para_dicionario(self):
        return {
            "id": self.id,
            "titulo": self.titulo,
            "temas": self.temas,
            "conteudo": self.conteudo,
            "autor": self.autor,
        }

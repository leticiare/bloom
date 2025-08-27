from dataclasses import dataclass


@dataclass
class Artigo:
    def __init__(self, titulo: str, temas: list[str], conteudo: str):
        self.titulo = titulo
        self.temas = temas
        self.conteudo = conteudo

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

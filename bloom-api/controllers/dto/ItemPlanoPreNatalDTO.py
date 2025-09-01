from dataclasses import dataclass

from domain.entities.PlanoPreNatal import ItemPlanoPreNatal


@dataclass
class ItemPlanoPreNatalDTO:
    id: str
    nome: str
    descricao: str
    semana_inicio: int
    semana_fim: int

    @classmethod
    def criar(cls, item: ItemPlanoPreNatal) -> "ItemPlanoPreNatalDTO":
        return cls(
            id=item.id,
            nome=item.nome,
            descricao=item.descricao,
            semana_inicio=item.semana_inicio,
            semana_fim=item.semana_fim,
        )

    def para_dicionario(self) -> dict:
        return {
            "id": self.id,
            "nome": self.nome,
            "descricao": self.descricao,
            "semana_inicio": self.semana_inicio,
            "semana_fim": self.semana_fim,
        }

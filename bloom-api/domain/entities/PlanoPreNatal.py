from dataclasses import dataclass


@dataclass
class ItemPlanoPreNatal:
    id: str
    nome: str
    descricao: str
    semana_inicio: int
    semana_fim: int

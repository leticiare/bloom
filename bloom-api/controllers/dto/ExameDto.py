from dataclasses import dataclass
from typing import Optional, override
from datetime import datetime

from domain.entities.EventoAgenda import StatusEvento
from domain.entities.Exame import Exame


@dataclass
class ExameDto:
    """DTO para transferência de dados de Exame"""
    id: str
    status: StatusEvento
    data_agendamento: Optional[datetime]
    data_realizacao: Optional[datetime]
    nome: str
    descricao: str
    semana_inicio: int
    semana_fim: int
    tipo: str


    @classmethod
    def criar(cls, exame: Exame) -> 'ExameDto':
        return cls(id=exame.id, status=exame.status, data_agendamento=exame.data_agendamento, data_realizacao=exame.data_realizacao, nome=exame.info_plano.nome, descricao=exame.info_plano.descricao, semana_inicio=exame.info_plano.semana_inicio, semana_fim=exame.info_plano.semana_fim, tipo=exame.tipo)

    def para_dicionario(self):
        return {
            'id': self.id,
            'status': self.status.value,
            'data_agendamento': self.data_agendamento.isoformat() if self.data_agendamento else None,
            'data_realizacao': self.data_realizacao.isoformat() if self.data_realizacao else None,
            'nome': self.nome,
            'descricao': self.descricao,
            'semana_inicio': self.semana_inicio,
            'semana_fim': self.semana_fim,
            'tipo': self.tipo
        }

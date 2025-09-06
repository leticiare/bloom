from dataclasses import dataclass

from typing import Optional
from datetime import datetime, date

from domain.entities.CalculadoraGestacional import CalculadoraGestacional
from domain.entities.EventoAgenda import StatusEvento, TipoEventoAgenda

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
    data_semana_inicio: date
    data_semana_fim: date
    tipo: TipoEventoAgenda

    @classmethod
    def criar(cls, exame: Exame, dum: date) -> "ExameDto":
        return cls(
            id=exame.id,
            status=exame.status,
            data_agendamento=exame.data_agendamento,
            data_realizacao=exame.data_realizacao,
            nome=exame.info_plano.nome,
            descricao=exame.info_plano.descricao,
            semana_inicio=exame.info_plano.semana_inicio,
            semana_fim=exame.info_plano.semana_fim,
            data_semana_inicio=CalculadoraGestacional.calcular_data_semana(
                dum=dum, semana=exame.info_plano.semana_inicio
            ),
            data_semana_fim=CalculadoraGestacional.calcular_data_semana(
                dum=dum, semana=exame.info_plano.semana_fim
            ),
            tipo=exame.tipo,
        )

    def para_dicionario(self):
        return {
            "id": self.id,
            "status": self.status.value,
            "data_agendamento": self.data_agendamento.isoformat()
            if self.data_agendamento
            else None,
            "data_realizacao": self.data_realizacao.isoformat()
            if self.data_realizacao
            else None,
            "nome": self.nome,
            "descricao": self.descricao,
            "semana_inicio": self.semana_inicio,
            "semana_fim": self.semana_fim,
            "data_semana_inicio": self.data_semana_inicio.isoformat(),
            "data_semana_fim": self.data_semana_fim.isoformat(),
            "tipo": self.tipo.value,
        }

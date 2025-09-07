from dataclasses import dataclass
from typing import Optional
from datetime import datetime, date

from domain.entities.EventoAgenda import StatusEvento, TipoEventoAgenda
from domain.entities.CalculadoraGestacional import CalculadoraGestacional
from domain.entities.Vacina import Vacina


@dataclass
class VacinaDto:
    """DTO para transferência de dados de Vacina"""

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
    def criar(cls, vacina: Vacina, dum: date) -> "VacinaDto":
        return cls(
            id=vacina.id,
            status=vacina.status,
            data_agendamento=vacina.data_agendamento,
            data_realizacao=vacina.data_realizacao,
            nome=vacina.info_plano.nome,
            descricao=vacina.info_plano.descricao,
            semana_inicio=vacina.info_plano.semana_inicio,
            semana_fim=vacina.info_plano.semana_fim,
            data_semana_inicio=CalculadoraGestacional.calcular_data_semana(
                dum=dum, semana=vacina.info_plano.semana_inicio
            ),
            data_semana_fim=CalculadoraGestacional.calcular_data_semana(
                dum=dum, semana=vacina.info_plano.semana_fim
            ),
            tipo=vacina.tipo,
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

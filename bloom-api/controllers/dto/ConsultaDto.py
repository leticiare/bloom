from dataclasses import dataclass
from typing import Optional
from datetime import datetime, date

from domain.entities.EventoAgenda import StatusEvento, TipoEventoAgenda
from domain.entities.CalculadoraGestacional import CalculadoraGestacional
from domain.entities.Consulta import Consulta


@dataclass
class ConsultaDto:
    """DTO para transferência de dados de Consulta"""

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
    observacoes: str
    tipo: TipoEventoAgenda

    @classmethod
    def criar(cls, consulta: Consulta, dum: date) -> "ConsultaDto":
        return cls(
            id=consulta.id,
            status=consulta.status,
            data_agendamento=consulta.data_agendamento,
            data_realizacao=consulta.data_realizacao,
            observacoes=consulta.observacoes,
            nome=consulta.info_plano.nome,
            descricao=consulta.info_plano.descricao,
            semana_inicio=consulta.info_plano.semana_inicio,
            semana_fim=consulta.info_plano.semana_fim,
            data_semana_inicio=CalculadoraGestacional.calcular_data_semana(
                dum=dum, semana=consulta.info_plano.semana_inicio
            ),
            data_semana_fim=CalculadoraGestacional.calcular_data_semana(
                dum=dum, semana=consulta.info_plano.semana_fim
            ),
            tipo=consulta.tipo,
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
            "observacoes": self.observacoes,
        }

from enum import Enum

from typing import List, Optional

from datetime import datetime
from domain.errors.evento_agenda import (
    EventoJaAgendadoError,
    EventoJaRealizadoError,
    EventoJaCanceladoError,
    EventoSemDataAgendamentoError,
)


class TipoEventoAgenda(Enum):
    EXAME = "exame"

    VACINA = "vacina"
    CONSULTA = "consulta"


class StatusEvento(Enum):
    PENDENTE = "pendente"
    AGENDADO = "agendado"
    REALIZADO = "realizado"
    CANCELADO = "cancelado"


class EventoAgenda:
    def __init__(
        self,
        id: str,
        status: StatusEvento,
        data_agendamento: Optional[datetime],
        data_realizacao: Optional[datetime],
        tipo: TipoEventoAgenda,
        observacoes: Optional[str] = None,

    ):
        self.id = id
        self.status = StatusEvento(status)
        self.data_agendamento = data_agendamento
        self.data_realizacao = data_realizacao
        self.tipo = tipo

        self.observacoes = observacoes

    def _validar_status(self, lista_status: List[StatusEvento]):
        mapa_excecoes = {
            StatusEvento.AGENDADO: EventoJaAgendadoError,
            StatusEvento.CANCELADO: EventoJaCanceladoError,
            StatusEvento.REALIZADO: EventoJaRealizadoError,
        }

        for status in lista_status:
            if self.status == status:

                raise mapa_excecoes[status]()


    def agendar(self, data_agendamento: datetime):
        self._validar_status([StatusEvento.AGENDADO, StatusEvento.REALIZADO])

        self.status = StatusEvento.AGENDADO
        self.data_agendamento = data_agendamento
        self.data_realizacao = None

    def realizar(self, data_realizacao: datetime | None = None):
        self._validar_status([StatusEvento.REALIZADO, StatusEvento.CANCELADO])

        if data_realizacao is None and self.data_agendamento is not None:

            raise EventoSemDataAgendamentoError()


        self.status = StatusEvento.REALIZADO
        self.data_realizacao = data_realizacao or self.data_agendamento

    def cancelar(self):
        self._validar_status([StatusEvento.CANCELADO, StatusEvento.REALIZADO])

        self.status = StatusEvento.CANCELADO

        self.data_agendamento = None
        self.data_realizacao = None


    def remarcar(self, data_agendamento: datetime):
        self._validar_status([StatusEvento.CANCELADO, StatusEvento.REALIZADO])

        self.status = StatusEvento.PENDENTE
        self.data_agendamento = data_agendamento
        self.data_realizacao = None

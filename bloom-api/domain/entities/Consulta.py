from typing import Optional
from datetime import datetime

from domain.entities.EventoAgenda import EventoAgenda, StatusEvento, TipoEventoAgenda
from domain.entities.PlanoPreNatal import ItemPlanoPreNatal


class Consulta(EventoAgenda):
    def __init__(
        self,
        id: str,
        data_agendamento: Optional[datetime],
        data_realizacao: Optional[datetime],
        observacoes: Optional[str],
        status: StatusEvento,
        gestante_id: str,
        info_plano: ItemPlanoPreNatal,
    ):
        super().__init__(
            id=id,
            data_agendamento=data_agendamento,
            data_realizacao=data_realizacao,
            status=status,
            tipo=TipoEventoAgenda.CONSULTA,
            gestante_id=gestante_id,
            observacoes=observacoes,
        )
        self.info_plano = info_plano

    def anotar_observacoes(self, observacoes: str):
        self.observacoes = observacoes

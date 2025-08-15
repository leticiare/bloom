from datetime import datetime

from domain.entities.EventoAgenda import EventoAgenda, StatusEvento
from domain.entities.PlanoPreNatal import ItemPlanoPreNatal


class Exame(EventoAgenda):
    def __init__(
        self,
        id: str,
        data_agendamento: datetime,
        data_realizacao: datetime,
        status: StatusEvento,
        info_plano: ItemPlanoPreNatal,
    ):
        super().__init__(
            id=id,
            data_agendamento=data_agendamento,
            data_realizacao=data_realizacao,
            status=status,
            tipo="exame",
        )
        self.info_plano = info_plano

<<<<<<< HEAD
=======

>>>>>>> telas-dashboard
from typing import Optional
from datetime import datetime

from domain.entities.EventoAgenda import EventoAgenda, StatusEvento, TipoEventoAgenda

from domain.entities.PlanoPreNatal import ItemPlanoPreNatal


class Exame(EventoAgenda):
    def __init__(
        self,
        id: str,
<<<<<<< HEAD
        data_agendamento: Optional[datetime],
        data_realizacao: Optional[datetime],
=======

        data_agendamento: Optional[datetime],
        data_realizacao: Optional[datetime],

>>>>>>> telas-dashboard
        status: StatusEvento,
        info_plano: ItemPlanoPreNatal,
    ):
        super().__init__(
            id=id,
            data_agendamento=data_agendamento,
            data_realizacao=data_realizacao,
            status=status,

            tipo=TipoEventoAgenda.EXAME,

        )
        self.info_plano = info_plano

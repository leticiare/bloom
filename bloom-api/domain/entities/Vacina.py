from datetime import datetime

from domain.entities.EventoAgenda import EventoAgenda, StatusEvento, TipoEventoAgenda
from domain.entities.PlanoPreNatal import ItemPlanoPreNatal


class Vacina(EventoAgenda):
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
            tipo=TipoEventoAgenda.VACINA,
        )
        self.info_plano = info_plano

    def aplicar(self, data_realizacao: datetime | None = None):
        return super().realizar(data_realizacao)

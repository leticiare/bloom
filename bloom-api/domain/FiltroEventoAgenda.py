from typing import List, Literal
from datetime import datetime
from domain.entities.EventoAgenda import EventoAgenda, StatusEvento


class FiltroEventoAgenda:
    @staticmethod
    def filtar_por_intervalo_data(
        eventos: List[EventoAgenda],
        data_inicio: datetime | None,
        data_fim: datetime | None,
    ) -> List[EventoAgenda]:
        if data_inicio is None and data_fim is None:
            return eventos

        def filtro(evento: EventoAgenda):
            """Realiza a filtragem com base em qualquer uma das datas"""
            datas = [evento.data_agendamento, evento.data_realizacao]
            for data in datas:
                if data is not None:
                    # Filtra se está entre o intervalo
                    if data_inicio and data_fim:
                        return data_inicio <= data <= data_fim

                    # Filtra apenas se for maior que a data de início
                    if data_inicio:
                        return data >= data_inicio

                    # Filtra apenas se for menor que a data de fim
                    if data_fim:
                        return data <= data_fim
            return False

        return filter(filtro, eventos)

    @staticmethod
    def filtrar_por_status(
        eventos: List[EventoAgenda],
        status: List[StatusEvento],
        comparacao: Literal["igual", "diferente"] = "igual",
    ):
        if len(status) == 0:
            return eventos

        if comparacao == "diferente":
            return [evento for evento in eventos if evento.status not in status]

        return [evento for evento in eventos if evento.status in status]

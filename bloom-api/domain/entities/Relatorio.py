from datetime import datetime

from .EventoAgenda import EventoAgenda


class Relatorio:
    def __init__(
        self,
        dataCriacao: datetime,
        situacaoVacinas: list[EventoAgenda],
        situacaoExames: list[EventoAgenda],
        historicoConsultas: list[EventoAgenda],
    ):
        self.dataCriacao = dataCriacao
        self.situacaoVacinas = situacaoVacinas
        self.situacaoExames = situacaoExames
        self.historicoConsultas = historicoConsultas

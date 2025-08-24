class StatusEventoError(Exception):
    pass


class EventoNaoEncontradoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Evento não encontrado: {id}")


class EventoJaRealizadoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Evento já realizado: {id}")


class EventoJaAgendadoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Evento já agendado: {id}")


class EventoJaCanceladoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Evento já cancelado: {id}")


class EventoSemDataAgendamentoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Evento sem data de agendamento: {id}")

class StatusEventoError(Exception):
    pass


class EventoNaoEncontradoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Exame não encontrado: {id}")


class EventoJaRealizadoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Exame já realizado: {id}")


class EventoJaAgendadoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Exame já agendado: {id}")


class EventoJaCanceladoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Exame já cancelado: {id}")


class EventoSemDataAgendamentoError(StatusEventoError):
    def __init__(self, id: str):
        super().__init__(f"Exame sem data de agendamento: {id}")

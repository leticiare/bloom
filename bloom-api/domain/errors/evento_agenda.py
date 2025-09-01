<<<<<<< HEAD
=======

>>>>>>> telas-dashboard
class EventoAgendaError(Exception):
    pass


class EventoNaoEncontradoError(EventoAgendaError):
    def __init__(self):
        super().__init__("Evento não encontrado.")


class EventoJaRealizadoError(EventoAgendaError):
    def __init__(self):
        super().__init__("Evento já realizado.")


class EventoJaAgendadoError(EventoAgendaError):
    def __init__(self):
        super().__init__("Evento já agendado.")


class EventoJaCanceladoError(EventoAgendaError):
    def __init__(self):
        super().__init__("Evento já cancelado.")


class EventoSemDataAgendamentoError(EventoAgendaError):
    def __init__(self):
        super().__init__("Evento sem data de agendamento.")

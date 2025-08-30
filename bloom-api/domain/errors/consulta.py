class ConsultaError(Exception):
    pass


class ConsultaNaoEncontradaError(ConsultaError):
    def __init__(self, id: str):
        super().__init__(f"Consulta não encontrada: {id}")


class ConsultaJaAgendadaError(ConsultaError):
    def __init__(self, id: str):
        super().__init__(f"Consulta já agendada: {id}")


class ConsultaJaRealizadaError(ConsultaError):
    def __init__(self, id: str):
        super().__init__(f"Consulta já realizada: {id}")


class ConsultaJaCanceladaError(ConsultaError):
    def __init__(self, id: str):
        super().__init__(f"Consulta já cancelada: {id}")


class ConsultaSemDataAgendamentoError(ConsultaError):
    def __init__(self, id: str):
        super().__init__(f"Consulta sem data de agendamento: {id}")

class ExameError(Exception):
    pass


class ExameNaoEncontradoError(ExameError):
    def __init__(self, id: str):
        super().__init__(f"Exame não encontrado: {id}")


class ExameJaAgendadoError(ExameError):
    def __init__(self, id: str):
        super().__init__(f"Exame já agendado: {id}")


class ExameJaRealizadoError(ExameError):
    def __init__(self, id: str):
        super().__init__(f"Exame já realizado: {id}")


class ExameJaCanceladoError(ExameError):
    def __init__(self, id: str):
        super().__init__(f"Exame já cancelado: {id}")


class ExameSemDataAgendamentoError(ExameError):
    def __init__(self, id: str):
        super().__init__(f"Exame sem data de agendamento: {id}")

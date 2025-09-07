class VacinaError(Exception):
    pass


class VacinaNaoEncontradaError(VacinaError):
    def __init__(self, id: str):
        super().__init__(f"Vacina não encontrada: {id}")


class VacinaJaAgendadaError(VacinaError):
    def __init__(self, id: str):
        super().__init__(f"Vacina já agendada: {id}")


class VacinaJaAplicadaError(VacinaError):
    def __init__(self, id: str):
        super().__init__(f"Vacina já aplicada: {id}")


class VacinaJaCanceladaError(VacinaError):
    def __init__(self, id: str):
        super().__init__(f"Vacina já cancelada: {id}")


class VacinaSemDataAgendamentoError(VacinaError):
    def __init__(self, id: str):
        super().__init__(f"Vacina sem data de agendamento: {id}")

from datetime import date, timedelta

SEMANAS_GESTACAO = 40


class CalculadoraGestacional:
    """
    Classe para realizar cálculos relacionados à gestação.
    """

    @classmethod
    def calcular_data_provavel_parto(cls, dum: date) -> date:
        """Calcula a data provável do parto com base na DUM (Data da última menstruação)."""
        dias = SEMANAS_GESTACAO * 7
        return dum + timedelta(days=dias)

    @classmethod
    def calcular_semana_atual(cls, dum: date, data_atual: date) -> int:
        """Calcula a semana atual da gestação com base na DUM (Data da última menstruação)."""
        dias_gestacao = (data_atual - dum).days
        return dias_gestacao // 7

    @classmethod
    def calcular_data_semana(cls, dum: date, semana: int) -> date:
        """Calcula a data de uma semana específica da gestação com base na DUM (Data da última menstruação)."""
        dias = semana * 7
        data_semana = dum + timedelta(days=dias)
        return data_semana

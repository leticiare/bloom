from domain.contracts.Documento import Documento


class CPF(Documento):
    def validar(self) -> bool:
        """Valida o número de CPF com base no algoritmo oficial."""
        if len(self.numero) != 11 or len(set(self.numero)) == 1:
            return False

        # Cálculo do primeiro dígito verificador
        soma = sum(int(self.numero[i]) * (10 - i) for i in range(9))
        digito1 = (soma * 10) % 11

        if digito1 == 10:
            digito1 = 0
        if digito1 != int(self.numero[9]):
            return False

        # Cálculo do segundo dígito verificador
        soma = sum(int(self.numero[i]) * (11 - i) for i in range(10))
        digito2 = (soma * 10) % 11
        if digito2 == 10:
            digito2 = 0
        if digito2 != int(self.numero[10]):
            return False

        return True

    def formatar(self) -> str:
        return (
            f"{self.numero[:3]}.{self.numero[3:6]}.{self.numero[6:9]}-{self.numero[9:]}"
        )

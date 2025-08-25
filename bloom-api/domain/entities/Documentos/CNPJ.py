from domain.contracts.Documento import Documento


class CNPJ(Documento):
    def validar(self) -> bool:
        if len(self.numero) != 14 or len(set(self.numero)) == 1:
            return False

        # Cálculo do primeiro dígito verificador
        pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(int(self.numero[i]) * pesos1[i] for i in range(12))
        resto = soma % 11
        digito1 = 0 if resto < 2 else 11 - resto
        if digito1 != int(self.numero[12]):
            return False

        # Cálculo do segundo dígito verificador
        pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(int(self.numero[i]) * pesos2[i] for i in range(13))
        resto = soma % 11
        digito2 = 0 if resto < 2 else 11 - resto
        if digito2 != int(self.numero[13]):
            return False

        return True

    def formatar(self) -> str:
        return f"{self.numero[:2]}.{self.numero[2:5]}.{self.numero[5:8]}/{self.numero[8:12]}-{self.numero[12:]}"

import re
from abc import ABC, abstractmethod


class Documento(ABC):
    """
    Classe base abstrata para diferentes tipos de documentos.
    """

    def __init__(self, numero: str):
        self.numero = self._limpar(numero)

    @staticmethod
    def _limpar(numero: str) -> str:
        """
        Limpa caracteres diferentes de números
        """
        return re.sub(r"\D", "", numero)

    def obter_numero(self):
        return self.numero

    @abstractmethod
    def validar(self) -> bool: ...

    @abstractmethod
    def formatar(self) -> str: ...

    def __str__(self) -> str:
        return self.formatar()

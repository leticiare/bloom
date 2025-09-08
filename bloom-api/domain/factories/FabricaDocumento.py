from domain.contracts.Documento import Documento
from domain.entities.Documentos.CNPJ import CNPJ
from domain.entities.Documentos.CPF import CPF
from domain.enums.TiposDocumento import TiposDocumento


class FabricaDocumento:
    def criar_documento(tipo: TiposDocumento, numero: str) -> Documento:
        tipo_map = {"cpf": CPF, "cnpj": CNPJ}
        # Usa o valor do Enum, que já está em minúsculo
        classe_documento = tipo_map.get(tipo.value.lower())

        if not classe_documento:
            raise ValueError(f"Tipo de documento '{tipo}' não suportado.")

        documento_obj = classe_documento(numero)

        if not documento_obj.validar():
            raise ValueError(f"Número de {tipo.value.upper()} inválido.")

        return documento_obj

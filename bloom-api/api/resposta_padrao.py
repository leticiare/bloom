from pydantic.generics import GenericModel
from typing import TypeVar, Generic, Optional

T = TypeVar("T")


class RespostaPadrao(GenericModel, Generic[T]):
    sucesso: bool
    dados: Optional[T]
    codigo_http: int
    mensagem: Optional[str] = None

from typing import Optional
from pydantic import BaseModel


class ArtigoDTO(BaseModel):
    id: Optional[str] = None
    titulo: str
    temas: list[str]
    conteudo: str
    autor: Optional[str] = None

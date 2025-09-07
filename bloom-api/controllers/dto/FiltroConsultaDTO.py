from pydantic import BaseModel


class FiltroConsultaDTO(BaseModel):
    temas: list[str] | None = None
    autor: str | None = None
    titulo: str | None = None

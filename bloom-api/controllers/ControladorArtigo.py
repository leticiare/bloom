import uuid

from domain.entities.Artigo import Artigo
from fastapi import HTTPException
from infra.logger.logger import logger
from infra.repositories.RepositorioArtigo import RepositorioArtigo

from controllers.dto.ArtigoDTO import ArtigoDTO
from controllers.dto.FiltroConsultaDTO import FiltroConsultaDTO


class ControladorArtigo:
    def __init__(self):
        self._repositorio = RepositorioArtigo()

    def escrever_artigo(self, artigo: ArtigoDTO, usuario: str) -> None:
        artigo = Artigo(
            str(uuid.uuid4()), artigo.titulo, artigo.temas, artigo.conteudo, usuario
        )
        self._repositorio.inserir(artigo=artigo)

    def excluir_artigo(self, id_artigo: str, usuario: str) -> None:
        artigo = self._repositorio.obter_por_id(id_artigo=id_artigo)

        if artigo is None:
            raise HTTPException(status_code=404, detail="Artigo não encontrado.")
        if artigo.autor != usuario:
            logger.info(
                f"{usuario} realizou tentativa do artigo de autor{artigo.autor}"
            )
            raise HTTPException(
                status_code=403,
                detail="Usuário não possui permissão para realizar ação.",
            )

        self._repositorio.excluir(id_artigo)

    def editar_artigo(self, artigo_dto: ArtigoDTO, usuario: str) -> None:
        artigo = self._repositorio.obter_por_id(id_artigo=artigo_dto.id)
        if artigo is None:
            raise HTTPException(status_code=404, detail="Artigo não encontrado.")

        # Validar permissão
        if artigo.autor != usuario:
            logger.info(f"{usuario} tentou editar artigo de {artigo.autor}")
            raise HTTPException(
                status_code=403,
                detail="Usuário não possui permissão para realizar ação.",
            )

        artigo.titulo = artigo_dto.titulo
        artigo.conteudo = artigo_dto.conteudo
        artigo.temas = artigo_dto.temas

        self._repositorio.editar(artigo)

    def obter(self, filtro: FiltroConsultaDTO):
        artigos = self.obter_todos()
        if filtro:
            if filtro.temas is not None:
                return self.obter_por_temas(filtro.temas, artigos)
            if filtro.autor is not None:
                return self.obter_por_autor(filtro.autor, artigos)
            if filtro.titulo is not None:
                return self.obter_por_titulo(filtro.titulo, artigos)

        return artigos

    def obter_todos(self) -> list["Artigo"]:
        return self._repositorio.obter_todos()

    def obter_por_temas(
        self, temas: list[str], artigos: list["Artigo"]
    ) -> list["Artigo"]:
        return [
            artigo
            for artigo in artigos
            if any(t.lower() in [at.lower() for at in artigo.temas] for t in temas)
        ]

    def obter_por_autor(self, id_autor: str, artigos: list["Artigo"]) -> list["Artigo"]:
        return [artigo for artigo in artigos if artigo.autor == id_autor]

    def obter_por_titulo(self, titulo: str, artigos: list["Artigo"]) -> list["Artigo"]:
        return [artigo for artigo in artigos if titulo.lower() in artigo.titulo.lower()]

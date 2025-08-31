from datetime import datetime
from controllers.dto.ExameDto import ExameDto
from domain.entities.EventoAgenda import StatusEvento, TipoEventoAgenda
from domain.errors.evento_agenda import StatusEventoError
from infra.repositories.RepositorioEventoAgenda import RepositorioEventoAgenda
from fastapi import HTTPException
from typing import List


class ControladorExame:
    def __init__(self):
        self._repositorio: RepositorioEventoAgenda = RepositorioEventoAgenda()

    def _filtrar_exames_por_intervalo(
        self,
        exames: List[ExameDto],
        data_inicio: datetime | None,
        data_fim: datetime | None,
    ):
        if data_inicio is None and data_fim is None:
            return exames

        def filtro(exame: ExameDto):
            """Realiza a filtragem com base em qualquer uma das datas"""
            datas = [exame.data_agendamento, exame.data_realizacao]
            for data in datas:
                if data is not None:
                    # Filtra se está entre o intervalo
                    if data_inicio and data_fim:
                        return data_inicio <= data <= data_fim

                    # Filtra apenas se for maior que a data de início
                    if data_inicio:
                        return data >= data_inicio

                    # Filtra apenas se for menor que a data de fim
                    if data_fim:
                        return data <= data_fim
            return False

        return filter(filtro, exames)

    def obter_todos(
        self, gestante_id: str, data_inicio: datetime | None, data_fim: datetime | None
    ):
        exames = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.EXAME
        )
        lista_exames = [ExameDto.criar(exame) for exame in exames]

        if data_inicio or data_fim:
            lista_exames = self._filtrar_exames_por_intervalo(
                exames=lista_exames, data_inicio=data_inicio, data_fim=data_fim
            )

        return [exame.para_dicionario() for exame in lista_exames]

    def obter_exames_agendados(self, gestante_id: str):
        exames = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.EXAME
        )
        lista_exames = [
            ExameDto.criar(exame).para_dicionario()
            for exame in exames
            if exame.status == StatusEvento.AGENDADO
        ]
        return lista_exames

    def obter_exames_nao_agendados(self, gestante_id: str):
        exames = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.EXAME
        )
        lista_exames = [
            ExameDto.criar(exame).para_dicionario()
            for exame in exames
            if exame.status != StatusEvento.AGENDADO
        ]
        return lista_exames

    def agendar_exame(self, exame_id: str, data_agendamento: datetime):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.agendar(data_agendamento)

            self._repositorio.atualizar(exame)

            dto = ExameDto.criar(exame)
            return dto.para_dicionario()
        except StatusEventoError as e:
            mensagem = str(e).replace("Evento", "Exame")

            raise HTTPException(status_code=400, detail=mensagem)

    def realizar_exame(self, exame_id: str, data_realizacao: datetime):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.realizar(data_realizacao=data_realizacao)

            self._repositorio.atualizar(exame)
            dto = ExameDto.criar(exame)
            return dto.para_dicionario()
        except StatusEventoError as e:
            mensagem = str(e).replace("Evento", "Exame")

            raise HTTPException(status_code=400, detail=mensagem)

    def remarcar_exame(self, exame_id: str, data_remarcacao: datetime):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.remarcar(data_agendamento=data_remarcacao)

            self._repositorio.atualizar(exame)
            dto = ExameDto.criar(exame)
            return dto.para_dicionario()
        except StatusEventoError as e:
            mensagem = str(e).replace("Evento", "Exame")

            raise HTTPException(status_code=400, detail=mensagem)

    def cancelar_exame(self, exame_id: str):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.cancelar()

            self._repositorio.atualizar(exame)
            dto = ExameDto.criar(exame)
            return dto.para_dicionario()
        except StatusEventoError as e:
            mensagem = str(e).replace("Evento", "Exame")

            raise HTTPException(status_code=400, detail=mensagem)

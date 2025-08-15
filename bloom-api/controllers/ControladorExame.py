from datetime import datetime
from controllers.dto.ExameDto import ExameDto
from domain.errors.evento_agenda import StatusEventoError
from infra.repositories.RepositorioExame import RepositorioExame
from fastapi import HTTPException


class ControladorExame:
    def __init__(self):
        self._repositorio: RepositorioExame = RepositorioExame()

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

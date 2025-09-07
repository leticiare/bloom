from datetime import datetime
from controllers.dto.VacinaDto import VacinaDto
from domain.entities.EventoAgenda import StatusEvento, TipoEventoAgenda
from domain.errors.evento_agenda import EventoAgendaError
from domain.errors.FabricaErroEventoAgenda import FabricaErroEventoAgenda
from domain.FiltroEventoAgenda import FiltroEventoAgenda
from infra.repositories.RepositorioEventoAgenda import RepositorioEventoAgenda
from fastapi import HTTPException


class ControladorVacina:
    def __init__(self):
        self._repositorio: RepositorioEventoAgenda = RepositorioEventoAgenda()

    def obter_todos(
        self, gestante_id: str, data_inicio: datetime | None, data_fim: datetime | None
    ):
        vacinas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.VACINA
        )

        if data_inicio or data_fim:
            vacinas = FiltroEventoAgenda.filtar_por_intervalo_data(
                eventos=vacinas, data_inicio=data_inicio, data_fim=data_fim
            )

        return [VacinaDto.criar(vacina).para_dicionario() for vacina in vacinas]

    def obter_vacinas_agendadas(self, gestante_id: str):
        vacinas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.VACINA
        )

        lista_vacinas = FiltroEventoAgenda.filtrar_por_status(
            eventos=vacinas, status=[StatusEvento.AGENDADO]
        )

        return [VacinaDto.criar(vacina).para_dicionario() for vacina in lista_vacinas]

    def obter_vacinas_realizadas(self, gestante_id: str):
        vacinas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.VACINA
        )

        lista_vacinas = FiltroEventoAgenda.filtrar_por_status(
            eventos=vacinas, status=[StatusEvento.REALIZADO]
        )

        return [VacinaDto.criar(vacina).para_dicionario() for vacina in lista_vacinas]

    def obter_vacinas_pendentes(self, gestante_id: str):
        vacinas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.VACINA
        )

        lista_vacinas = FiltroEventoAgenda.filtrar_por_status(
            eventos=vacinas, status=[StatusEvento.PENDENTE, StatusEvento.CANCELADO]
        )

        return [VacinaDto.criar(vacina).para_dicionario() for vacina in lista_vacinas]

    def agendar_vacina(self, vacina_id: str, data_agendamento: datetime):
        try:
            vacina = self._repositorio.obter_por_id(vacina_id)

            if vacina is None:
                raise HTTPException(status_code=404, detail="Vacina não encontrada")

            vacina.agendar(data_agendamento)

            self._repositorio.atualizar(vacina)

            dto = VacinaDto.criar(vacina)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.VACINA)(
                vacina_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

    def aplicar_vacina(self, vacina_id: str, data_realizacao: datetime):
        try:
            vacina = self._repositorio.obter_por_id(vacina_id)

            if vacina is None:
                raise HTTPException(status_code=404, detail="Vacina não encontrada")

            vacina.aplicar(data_realizacao=data_realizacao)

            self._repositorio.atualizar(vacina)
            dto = VacinaDto.criar(vacina)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.VACINA)(
                vacina_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

    def remarcar_vacina(self, vacina_id: str, data_remarcacao: datetime):
        try:
            vacina = self._repositorio.obter_por_id(vacina_id)

            if vacina is None:
                raise HTTPException(status_code=404, detail="Vacina não encontrada")

            vacina.remarcar(data_agendamento=data_remarcacao)

            self._repositorio.atualizar(vacina)
            dto = VacinaDto.criar(vacina)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.VACINA)(
                vacina_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

    def cancelar_vacina(self, vacina_id: str):
        try:
            vacina = self._repositorio.obter_por_id(vacina_id)

            if vacina is None:
                raise HTTPException(status_code=404, detail="Vacina não encontrada")

            vacina.cancelar()

            self._repositorio.atualizar(vacina)
            dto = VacinaDto.criar(vacina)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.VACINA)(
                vacina_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

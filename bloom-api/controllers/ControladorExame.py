from datetime import datetime
from controllers.dto.ExameDto import ExameDto
from domain.entities.EventoAgenda import StatusEvento, TipoEventoAgenda
from domain.errors.evento_agenda import EventoAgendaError
from domain.errors.FabricaErroEventoAgenda import FabricaErroEventoAgenda
from domain.FiltroEventoAgenda import FiltroEventoAgenda
from infra.repositories.RepositorioEventoAgenda import RepositorioEventoAgenda



class ControladorExame:
    def __init__(self):
        self._repositorio: RepositorioEventoAgenda = RepositorioEventoAgenda()


    def obter_todos(
        self, gestante_id: str, data_inicio: datetime | None, data_fim: datetime | None
    ):
        exames = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.EXAME
        )


        if data_inicio or data_fim:
            exames = FiltroEventoAgenda.filtar_por_intervalo_data(
                eventos=exames, data_inicio=data_inicio, data_fim=data_fim
            )

        return [ExameDto.criar(exame).para_dicionario() for exame in exames]


    def obter_exames_agendados(self, gestante_id: str):
        exames = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.EXAME
        )


        lista_exames = FiltroEventoAgenda.filtrar_por_status(
            eventos=exames, status=[StatusEvento.AGENDADO]
        )

        return [ExameDto.criar(exame).para_dicionario() for exame in lista_exames]

    def obter_exames_pendentes(self, gestante_id: str):
        exames = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.EXAME
        )

        lista_exames = FiltroEventoAgenda.filtrar_por_status(
            eventos=exames, status=[StatusEvento.PENDENTE, StatusEvento.CANCELADO]
        )

        return [ExameDto.criar(exame).para_dicionario() for exame in lista_exames]


    def agendar_exame(self, exame_id: str, data_agendamento: datetime):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.agendar(data_agendamento)

            self._repositorio.atualizar(exame)

            dto = ExameDto.criar(exame)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.EXAME)(
                exame_id
            )
            raise HTTPException(status_code=400, detail=str(mensagem))

    def realizar_exame(self, exame_id: str, data_realizacao: datetime):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.realizar(data_realizacao=data_realizacao)

            self._repositorio.atualizar(exame)
            dto = ExameDto.criar(exame)
            return dto.para_dicionario()

        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.EXAME)(
                exame_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))


    def remarcar_exame(self, exame_id: str, data_remarcacao: datetime):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.remarcar(data_agendamento=data_remarcacao)

            self._repositorio.atualizar(exame)
            dto = ExameDto.criar(exame)
            return dto.para_dicionario()

        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.EXAME)(
                exame_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))


    def cancelar_exame(self, exame_id: str):
        try:
            exame = self._repositorio.obter_por_id(exame_id)

            if exame is None:
                raise HTTPException(status_code=404, detail="Exame não encontrado")

            exame.cancelar()

            self._repositorio.atualizar(exame)
            dto = ExameDto.criar(exame)
            return dto.para_dicionario()

        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.EXAME)(
                exame_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

from datetime import datetime
from controllers.dto.ConsultaDto import ConsultaDto
from domain.entities.EventoAgenda import StatusEvento, TipoEventoAgenda
from domain.errors.evento_agenda import EventoAgendaError
from domain.errors.FabricaErroEventoAgenda import FabricaErroEventoAgenda
from domain.FiltroEventoAgenda import FiltroEventoAgenda
from infra.repositories.RepositorioEventoAgenda import RepositorioEventoAgenda
from infra.repositories.RepositorioGestante import RepositorioGestante
from fastapi import HTTPException


class ControladorConsulta:
    def __init__(self):
        self._repositorio: RepositorioEventoAgenda = RepositorioEventoAgenda()
        self._repositorio_gestante: RepositorioGestante = RepositorioGestante()

    def obter_todos(
        self, gestante_id: str, data_inicio: datetime | None, data_fim: datetime | None
    ):
        dum = self._repositorio_gestante.obter_dum_gestante(gestante_id)
        consultas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.CONSULTA
        )

        if data_inicio or data_fim:
            consultas = FiltroEventoAgenda.filtar_por_intervalo_data(
                eventos=consultas, data_inicio=data_inicio, data_fim=data_fim
            )

        return [
            ConsultaDto.criar(consulta=consulta, dum=dum).para_dicionario()
            for consulta in consultas
        ]

    def obter_consultas_agendadas(self, gestante_id: str):
        dum = self._repositorio_gestante.obter_dum_gestante(gestante_id)
        consultas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.CONSULTA
        )

        lista_consultas = FiltroEventoAgenda.filtrar_por_status(
            eventos=consultas, status=[StatusEvento.AGENDADO]
        )

        return [
            ConsultaDto.criar(consulta=consulta, dum=dum).para_dicionario()
            for consulta in lista_consultas
        ]

    def obter_consultas_realizadas(self, gestante_id: str):
        dum = self._repositorio_gestante.obter_dum_gestante(gestante_id)
        consultas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.CONSULTA
        )

        lista_consultas = FiltroEventoAgenda.filtrar_por_status(
            eventos=consultas, status=[StatusEvento.REALIZADO]
        )

        return [
            ConsultaDto.criar(consulta).para_dicionario()
            for consulta in lista_consultas
        ]

    def obter_consultas_pendentes(self, gestante_id: str):
        dum = self._repositorio_gestante.obter_dum_gestante(gestante_id)
        consultas = self._repositorio.obter_todos_por_gestante(
            gestante_id=gestante_id, tipo=TipoEventoAgenda.CONSULTA
        )

        lista_consultas = FiltroEventoAgenda.filtrar_por_status(
            eventos=consultas, status=[StatusEvento.PENDENTE, StatusEvento.CANCELADO]
        )

        return [
            ConsultaDto.criar(consulta=consulta, dum=dum).para_dicionario()
            for consulta in lista_consultas
        ]

    def agendar_consulta(self, consulta_id: str, data_agendamento: datetime):
        try:
            consulta = self._repositorio.obter_por_id(consulta_id)
            dum = self._repositorio_gestante.obter_dum_gestante(consulta.gestante_id)

            if consulta is None:
                raise HTTPException(status_code=404, detail="Consulta não encontrada")

            consulta.agendar(data_agendamento)

            self._repositorio.atualizar(consulta)

            dto = ConsultaDto.criar(consulta=consulta, dum=dum)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.CONSULTA)(
                consulta_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

    def realizar_consulta(self, consulta_id: str, data_realizacao: datetime):
        try:
            consulta = self._repositorio.obter_por_id(consulta_id)
            dum = self._repositorio_gestante.obter_dum_gestante(consulta.gestante_id)

            if consulta is None:
                raise HTTPException(status_code=404, detail="Consulta não encontrada")

            consulta.realizar(data_realizacao=data_realizacao)

            self._repositorio.atualizar(consulta)
            dto = ConsultaDto.criar(consulta=consulta, dum=dum)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.CONSULTA)(
                consulta_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

    def remarcar_consulta(self, consulta_id: str, data_remarcacao: datetime):
        try:
            consulta = self._repositorio.obter_por_id(consulta_id)
            dum = self._repositorio_gestante.obter_dum_gestante(consulta.gestante_id)

            if consulta is None:
                raise HTTPException(status_code=404, detail="Consulta não encontrada")

            consulta.remarcar(data_agendamento=data_remarcacao)

            self._repositorio.atualizar(consulta)
            dto = ConsultaDto.criar(consulta=consulta, dum=dum)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.CONSULTA)(
                consulta_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

    def cancelar_consulta(self, consulta_id: str):
        try:
            consulta = self._repositorio.obter_por_id(consulta_id)
            dum = self._repositorio_gestante.obter_dum_gestante(consulta.gestante_id)

            if consulta is None:
                raise HTTPException(status_code=404, detail="Consulta não encontrada")

            consulta.cancelar()

            self._repositorio.atualizar(consulta)
            dto = ConsultaDto.criar(consulta=consulta, dum=dum)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.CONSULTA)(
                consulta_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

    def anotar_observacao_consulta(self, consulta_id: str, observacoes: str):
        try:
            consulta = self._repositorio.obter_por_id(consulta_id)
            dum = self._repositorio_gestante.obter_dum_gestante(consulta.gestante_id)

            if consulta is None:
                raise HTTPException(status_code=404, detail="Consulta não encontrada")

            consulta.anotar_observacoes(observacoes)

            self._repositorio.atualizar(consulta)
            dto = ConsultaDto.criar(consulta=consulta, dum=dum)
            return dto.para_dicionario()
        except EventoAgendaError as e:
            mensagem = FabricaErroEventoAgenda.criar(e, TipoEventoAgenda.CONSULTA)(
                consulta_id
            )

            raise HTTPException(status_code=400, detail=str(mensagem))

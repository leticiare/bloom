from domain.entities.EventoAgenda import TipoEventoAgenda
from domain.errors.evento_agenda import (
    EventoAgendaError,
    EventoJaAgendadoError,
    EventoJaCanceladoError,
    EventoJaRealizadoError,
    EventoNaoEncontradoError,
    EventoSemDataAgendamentoError,
)
from domain.errors.consulta import (
    ConsultaJaAgendadaError,
    ConsultaJaCanceladaError,
    ConsultaNaoEncontradaError,
    ConsultaJaRealizadaError,
    ConsultaSemDataAgendamentoError,
)
from domain.errors.exames import (
    ExameJaAgendadoError,
    ExameJaCanceladoError,
    ExameJaRealizadoError,
    ExameNaoEncontradoError,
    ExameSemDataAgendamentoError,
)
from domain.errors.vacinas import (
    VacinaJaAgendadaError,
    VacinaJaAplicadaError,
    VacinaJaCanceladaError,
    VacinaSemDataAgendamentoError,
    VacinaNaoEncontradaError,
)


class FabricaErroEventoAgenda:
    @staticmethod
    def criar(
        instancia_erro_generica: EventoAgendaError, tipo_evento_agenda: TipoEventoAgenda
    ):
        mapa_erros = {
            EventoJaAgendadoError: {
                TipoEventoAgenda.CONSULTA: ConsultaJaAgendadaError,
                TipoEventoAgenda.EXAME: ExameJaAgendadoError,
                TipoEventoAgenda.VACINA: VacinaJaAgendadaError,
            },
            EventoJaCanceladoError: {
                TipoEventoAgenda.CONSULTA: ConsultaJaCanceladaError,
                TipoEventoAgenda.EXAME: ExameJaCanceladoError,
                TipoEventoAgenda.VACINA: VacinaJaCanceladaError,
            },
            EventoJaRealizadoError: {
                TipoEventoAgenda.CONSULTA: ConsultaJaRealizadaError,
                TipoEventoAgenda.EXAME: ExameJaRealizadoError,
                TipoEventoAgenda.VACINA: VacinaJaAplicadaError,
            },
            EventoNaoEncontradoError: {
                TipoEventoAgenda.CONSULTA: ConsultaNaoEncontradaError,
                TipoEventoAgenda.EXAME: ExameNaoEncontradoError,
                TipoEventoAgenda.VACINA: VacinaNaoEncontradaError,
            },
            EventoSemDataAgendamentoError: {
                TipoEventoAgenda.CONSULTA: ConsultaSemDataAgendamentoError,
                TipoEventoAgenda.EXAME: ExameSemDataAgendamentoError,
                TipoEventoAgenda.VACINA: VacinaSemDataAgendamentoError,
            },
        }

        erro = mapa_erros.get(type(instancia_erro_generica))

        if erro is None:
            raise ValueError(f"Tipo de erro desconhecido: {instancia_erro_generica}")

        erro_especifico = erro.get(tipo_evento_agenda)

        if erro_especifico is None:
            raise ValueError(f"Tipo de evento desconhecido: {tipo_evento_agenda}")

        return erro_especifico

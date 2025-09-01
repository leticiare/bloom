from typing import TypedDict
from domain.entities.EventoAgenda import EventoAgenda, TipoEventoAgenda
from domain.entities.Exame import Exame

from domain.entities.Vacina import Vacina
from domain.entities.Consulta import Consulta
<<<<<<< HEAD
=======

>>>>>>> telas-dashboard
from domain.entities.PlanoPreNatal import ItemPlanoPreNatal


class DadosItemPlanoPreNatal(TypedDict):
    id: str
    nome: str
    descricao: str
    semana_inicio: int
    semana_fim: int


class DadosEventoAgenda(TypedDict):
    id: str
    status: str
    data_agendamento: str
    data_realizacao: str
    observacoes: str
    tipo: TipoEventoAgenda
    info_plano: DadosItemPlanoPreNatal | None


class FabricaEventoAgenda:
    @staticmethod
    def criar_evento_agenda(dados: DadosEventoAgenda) -> EventoAgenda:
        mapa_tipo_classe = {
            TipoEventoAgenda.EXAME.value: Exame,
            TipoEventoAgenda.VACINA.value: Vacina,
            TipoEventoAgenda.CONSULTA.value: Consulta,
        }


        info_plano = None

        if (dados.get("info_plano")) is not None:
            info_plano = ItemPlanoPreNatal(
                id=dados.get("info_plano").get("id"),
                nome=dados.get("info_plano").get("nome"),
                descricao=dados.get("info_plano").get("descricao"),
                semana_inicio=dados.get("info_plano").get("semana_inicio"),
                semana_fim=dados.get("info_plano").get("semana_fim"),
            )

        ClasseEventoAgenda = mapa_tipo_classe.get(dados.get("tipo"))

        if ClasseEventoAgenda is None:
            raise ValueError(f"Tipo de evento desconhecido: {dados.get('tipo')}")

        # A classe Consulta possui um campo 'observacoes' que as outras classes não possuem, por isso precisa de um tratamento específico
        if ClasseEventoAgenda == Consulta:
            return ClasseEventoAgenda(
<<<<<<< HEAD
=======

>>>>>>> telas-dashboard
                id=dados.get("id"),
                status=dados.get("status"),
                data_agendamento=dados.get("data_agendamento"),
                data_realizacao=dados.get("data_realizacao"),
                info_plano=info_plano,
<<<<<<< HEAD
=======

>>>>>>> telas-dashboard
                observacoes=dados.get("observacoes"),
            )

        return ClasseEventoAgenda(
            id=dados.get("id"),
            status=dados.get("status"),
            data_agendamento=dados.get("data_agendamento"),
            data_realizacao=dados.get("data_realizacao"),
            info_plano=info_plano,
        )

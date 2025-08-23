
-- Criação do schema
CREATE SCHEMA IF NOT EXISTS bloom_db;
SET search_path TO bloom_db;

-- Criação de tipos ENUM
CREATE TYPE plano_pre_natal_tipo AS ENUM ('consulta', 'exame', 'vacina');
CREATE TYPE agenda_status AS ENUM ('pendente', 'agendado', 'cancelado', 'realizado');
CREATE TYPE notificacao_tipo AS ENUM ('lembrete', 'alerta', 'sistema');
CREATE TYPE notificacao_status AS ENUM ('lida', 'nao_lida');
CREATE TYPE usuario_perfil AS ENUM ('gestante', 'profissional');

-- Tabela: plano_pre_natal
CREATE TABLE plano_pre_natal (
    id UUID PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    semana_inicio INTEGER NOT NULL,
    semana_fim INTEGER NOT NULL,
    tipo plano_pre_natal_tipo NOT NULL
);

-- Tabela: usuario
CREATE TABLE usuario (
    email VARCHAR(100) PRIMARY KEY,
    senha VARCHAR(255) NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    perfil usuario_perfil NOT NULL
);

-- Tabela: notificacao
CREATE TABLE notificacao (
    id VARCHAR(16) PRIMARY KEY,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    mensagem TEXT NOT NULL,
    tipo notificacao_tipo NOT NULL,
    status notificacao_status NOT NULL,
    usuario_email VARCHAR(100) NOT NULL,
    referencia_tipo TEXT,
    referencia_id UUID,
    CONSTRAINT fk_notificacao_usuario
        FOREIGN KEY (usuario_email)
        REFERENCES usuario(email)
);

-- Tabela: gestante
CREATE TABLE gestante (
    id UUID PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    dum TIMESTAMP WITH TIME ZONE NOT NULL,
    dpp TIMESTAMP WITH TIME ZONE NOT NULL,
    antecedentes_familiares TEXT,
    antecedentes_ginecologicos TEXT,
    antecedentes_obstetricos TEXT,
    usuario_email VARCHAR(100) NOT NULL,
    CONSTRAINT fk_gestante_usuario
        FOREIGN KEY (usuario_email)
        REFERENCES usuario(email)
);

-- Tabela: agenda
CREATE TABLE agenda (
    id UUID PRIMARY KEY,
    status agenda_status NOT NULL DEFAULT 'pendente',
    data_agendamento TIMESTAMP WITH TIME ZONE,
    data_realizacao TIMESTAMP WITH TIME ZONE,
    item_plano_pre_natal_id UUID,
    observacoes TEXT,
    tipo plano_pre_natal_tipo NOT NULL,
    gestante_id UUID NOT NULL,
    CONSTRAINT fk_agenda_plano_pre_natal
        FOREIGN KEY (item_plano_pre_natal_id)
        REFERENCES plano_pre_natal(id),
    CONSTRAINT fk_agenda_gestante
        FOREIGN KEY (gestante_id)
        REFERENCES gestante(id)
);

-- Tabela: profissional_saude
CREATE TABLE profissional_saude (
    codigo UUID PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(36) NOT NULL,
    usuario_email VARCHAR(100) NOT NULL,
    CONSTRAINT fk_profissional_saude_usuario
        FOREIGN KEY (usuario_email)
        REFERENCES usuario(email)
);

-- Tabela: relatorio
CREATE TABLE relatorio (
    id UUID PRIMARY KEY,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    caminho_arquivo VARCHAR(255) NOT NULL,
    gestantes_id UUID NOT NULL,
    CONSTRAINT fk_relatorios_gestantes
        FOREIGN KEY (gestantes_id)
        REFERENCES gestante(id)
);

-- Tabela: topico
CREATE TABLE topico (
    id UUID PRIMARY KEY,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    titulo VARCHAR(100) NOT NULL,
    conteudo TEXT NOT NULL,
    usuario_email VARCHAR(100) NOT NULL,
    CONSTRAINT fk_topico_usuario
        FOREIGN KEY (usuario_email)
        REFERENCES usuario(email)
);

-- Tabela: resposta_topico
CREATE TABLE resposta_topico (
    id UUID PRIMARY KEY,
    conteudo TEXT NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    topico_id UUID NOT NULL,
    usuario_email VARCHAR(100) NOT NULL,
    CONSTRAINT fk_resposta_topico
        FOREIGN KEY (topico_id)
        REFERENCES topico(id),
    CONSTRAINT fk_resposta_topico_usuario
        FOREIGN KEY (usuario_email)
        REFERENCES usuario(email)
);

-- Tabela: artigo
CREATE TABLE artigo (
    id UUID PRIMARY KEY,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    titulo VARCHAR(100) NOT NULL,
    conteudo TEXT NOT NULL,
    usuario_email VARCHAR(100) NOT NULL,
    CONSTRAINT fk_artigo_usuario
        FOREIGN KEY (usuario_email)
        REFERENCES usuario(email)
);

-- Tabela: tema
CREATE TABLE tema (
    id UUID PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Tabela: tema_topico
CREATE TABLE tema_topico (
    tema_id UUID NOT NULL,
    topico_id UUID NOT NULL,
    PRIMARY KEY (tema_id, topico_id),
    CONSTRAINT fk_tema_has_topico_tema
        FOREIGN KEY (tema_id)
        REFERENCES tema(id),
    CONSTRAINT fk_tema_has_topico_topico
        FOREIGN KEY (topico_id)
        REFERENCES topico(id)
);

-- Tabela: tema_artigo
CREATE TABLE tema_artigo (
    tema_id UUID NOT NULL,
    artigo_id UUID NOT NULL,
    PRIMARY KEY (tema_id, artigo_id),
    CONSTRAINT fk_tema_has_artigo_tema
        FOREIGN KEY (tema_id)
        REFERENCES tema(id),
    CONSTRAINT fk_tema_has_artigo_artigo
        FOREIGN KEY (artigo_id)
        REFERENCES artigo(id)
);

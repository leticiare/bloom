import hashlib
import infra.db.iniciar_db
from infra.db.conexao import ConexaoBancoDados

# Comando para executar a inserção: poetry run python -m scripts.insercao_dados_testes_db

infra.db.iniciar_db.conexao

conexao = ConexaoBancoDados.obter_instancia()

# Função para criptografar a senha usando SHA256
def criptografar_senha(senha):
    hash_obj = hashlib.sha256()
    hash_obj.update(senha.encode('utf-8'))
    return hash_obj.hexdigest()

# Criptografa as senhas
senha_ana_criptografada = criptografar_senha('senha123')
senha_maria_criptografada = criptografar_senha('senha456')

# Inserir usuários com senhas criptografadas
conexao.executar_sql(f"""
    INSERT INTO usuario (email, senha, documento, tipo_documento, data_nascimento, perfil, id_entidade_perfil) VALUES
    ('ana.silva@email.com', '{senha_ana_criptografada}', '111.111.111-11', 'cpf', '1990-01-01', 'gestante', '11111111-1111-1111-1111-111111111111'),
    ('maria.souza@email.com', '{senha_maria_criptografada}', '222.222.222-22', 'cpf', '1995-05-05', 'gestante', '22222222-2222-2222-2222-222222222222')
    ON CONFLICT (email) DO NOTHING;
""")

# Inserir gestantes
conexao.executar_sql("""
    INSERT INTO gestante (id, nome, dum, dpp, antecedentes_familiares, antecedentes_ginecologicos, antecedentes_obstetricos, usuario_email) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Ana Silva', '2025-05-01T08:00:00Z', '2026-02-05T08:00:00Z', 'Diabetes', 'Nenhum', 'Parto normal', 'ana.silva@email.com'),
    ('22222222-2222-2222-2222-222222222222', 'Maria Souza', '2025-04-15T08:00:00Z', '2026-01-20T08:00:00Z', 'Hipertensão', 'Mioma', 'Cesárea', 'maria.souza@email.com')
    ON CONFLICT (id) DO NOTHING;
""")


# Inserir itens do plano pré-natal
conexao.executar_sql("""
    INSERT INTO plano_pre_natal (id, nome, descricao, semana_inicio, semana_fim, tipo) VALUES
    ('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'Consulta Inicial', 'Primeira consulta do pré-natal', 1, 12, 'consulta'),
    ('aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'Ultrassom Morfológico', 'Exame de ultrassom morfológico', 12, 14, 'exame'),
    ('aaaaaaa3-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 'Vacina dTpa', 'Vacina contra difteria, tétano e coqueluche', 20, 36, 'vacina'),
    ('aaaaaaa4-aaaa-aaaa-aaaa-aaaaaaaaaaa4', 'Exame de Glicemia', 'Exame para detectar diabetes gestacional', 24, 28, 'exame'),
    ('aaaaaaa5-aaaa-aaaa-aaaa-aaaaaaaaaaa5', 'Consulta de Rotina', 'Consulta de acompanhamento', 13, 40, 'consulta'),
    ('aaaaaaa6-aaaa-aaaa-aaaa-aaaaaaaaaaa6', 'TOTG e Curva Glicêmica',  'Exame realizado com o objetivo de analisar e identificar indícios de diabetes gestacional',    24, 28, 'exame')
    ON CONFLICT (id) DO NOTHING;
""")

# Inserir eventos da agenda
conexao.executar_sql("""
    INSERT INTO agenda (id, status, data_agendamento, data_realizacao, item_plano_pre_natal_id, observacoes, tipo, gestante_id) VALUES
    ('bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'pendente', '2025-06-01T09:00:00Z', NULL, 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'Primeira consulta marcada', 'consulta', '11111111-1111-1111-1111-111111111111'),
    ('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'agendado', '2025-07-10T10:00:00Z', NULL, 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'Ultrassom agendado', 'exame', '11111111-1111-1111-1111-111111111111'),
    ('bbbbbbb3-bbbb-bbbb-bbbb-bbbbbbbbbbb3', 'realizado', '2025-08-15T11:00:00Z', '2025-08-15T11:30:00Z', 'aaaaaaa3-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 'Vacina aplicada', 'vacina', '22222222-2222-2222-2222-222222222222'),
    ('bbbbbbb4-bbbb-bbbb-bbbb-bbbbbbbbbbb4', 'cancelado', '2025-09-05T09:30:00Z', NULL, 'aaaaaaa4-aaaa-aaaa-aaaa-aaaaaaaaaaa4', 'Exame cancelado', 'exame', '22222222-2222-2222-2222-222222222222'),
    ('bbbbbbb5-bbbb-bbbb-bbbb-bbbbbbbbbbb5', 'pendente', '2025-10-20T14:00:00Z', NULL, 'aaaaaaa5-aaaa-aaaa-aaaa-aaaaaaaaaaa5', 'Consulta de rotina', 'consulta', '11111111-1111-1111-1111-111111111111'),
    ('bbbbbbb6-bbbb-bbbb-bbbb-bbbbbbbbbbb6', 'pendente', NULL, NULL, 'aaaaaaa6-aaaa-aaaa-aaaa-aaaaaaaaaaa6', NULL, 'exame', '22222222-2222-2222-2222-222222222222')
    ON CONFLICT (id) DO NOTHING;
""")
# 🚀 Bloom API

Este módulo é o backend da aplicação Bloom, desenvolvido com **FastAPI** e **Python**. Ele é responsável por fornecer a API RESTful que o frontend consome, além de gerenciar a lógica de negócios e a comunicação com o banco de dados PostgreSQL.

## Estrutura de Diretórios

```
/bloom-api
│
├── /auth                      # Módulo com serviços de autenticação e autorização
├── /api                       # Controllers e rotas (View + Controller)
│   ├── /v1
│   │   ├── vacinas.py
│   │   ├── consultas.py
│   │   └── ...
│   └── /middlewares           # Middlewares para autenticação, padronização de retorno, etc.
├── /controllers               # Módulo com controladores das operações
│   └── /dto                   # Possui classes que definem o formato de transferência de dados
├── /data                      # Contém qualquer tipo de arquivo que possuem dados adicionais (ex.: CSV com dados do plano pré-natal)
├── /domain                    # Módulo principal da aplicação que contém todas as classes e operações de negócio
│   ├── /contracts             # Interfaces e contratos para serviços, repositórios, etc.
│   ├── /entities              # Entidades de domínio (ex.: Vacina, Consulta, Exame, Gestante, Relatorio)
│   ├── /enums                 # Enumerações usadas no domínio (ex.: StatusEvento, TiposDocumento) 
│   ├── /errors                # Erros que podem ser lançados (ex.: EventoJaAgendadoError)
│   ├── /factories             # Fábricas para criação de objetos complexos
│   ├── /services              # Serviços de domínio (ex.: PerfilService)
├── /infra                     # Módulo de infraestrutura que lida com a camada mais baixa da aplicação, com interação direta com o banco de dados.
│   ├── /db                    # Configuração e conexão com o banco de dados (PostgreSQL)
│   ├── /logger                # Configuração de logging
│   ├── /repositories          # Repositórios para acesso a dados, fazendo a ponte entre o domínio e a camada de infraestrutura
│   └── /schemas               # Schemas das tabelas do banco de dados
│       ├── UsuarioSchema.py
│       └── ..
├── /logs                      # Arquivos de log da aplicação
├── /scripts                   # Scripts para inicialização e manutenção do banco de dados
│   └── /iniciar_db.sql        # Arquivo SQL para inicializar o banco de dados com as tabelas necessárias
├── /templates                 # Templates para geração de documentos (ex.: relatórios)
├── main.py                    # Entry point FastAPI
├── poetry.lock                # Arquivo de bloqueio do Poetry para garantir versões consistentes das dependências
├── poetry.lock                # Arquivo de bloqueio do Poetry para garantir versões consistentes das dependências
└── pyproject.toml             # Configuração do Poetry e dependências do projeto
```

## Como rodar o projeto (API)

### 1. Requisitos

- Python 3.12
- Poetry instalado (https://python-poetry.org/docs/#installation)
- Docker ou Servidor do PostgreSQL na versão 17
- CLI do PostgreSQL (psql)
- PgAdmin (opcional, para gerenciamento visual do banco de dados)

### 2. Iniciar servidor PostgreSQL

Você pode iniciar o PostgreSQL de duas formas:

#### a) Usando Docker

Execute o comando abaixo para subir um container PostgreSQL 17:

```bash
docker run --name bloom-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=bloom -p 5432:5432 -d postgres:17
```

Isso irá criar um banco chamado `bloom` com usuário e senha `postgres` na porta padrão 5432. Defina o nome do banco e as credenciais de usuário como preferir.

Para parar o container:

```bash
docker stop bloom-postgres
```

Para iniciar novamente:

```bash
docker start bloom-postgres
```

#### b) Usando o servidor PostgreSQL 17 instalado localmente

1. Certifique-se de que o PostgreSQL 17 está instalado e rodando em sua máquina.
2. Crie um banco de dados chamado `bloom` e um usuário `postgres` com senha `postgres` (ou ajuste as variáveis de ambiente conforme necessário).
3. O serviço geralmente pode ser iniciado com:

```bash
sudo service postgresql start
```

Ou, dependendo do sistema:

```bash
sudo systemctl start postgresql
```

4. Para acessar o banco via terminal:

```bash
psql -U postgres -h localhost -d bloom
```

### 3. Inicializar o banco de dados

Após criar o banco de dados, é necessário inicializar o banco com as tabelas e dados iniciais. Para isso, execute o seguinte comando:

```bash
psql -U postgres -h localhost -d bloom -f ./scripts/iniciar_bd.sql
```

Isso irá criar as tabelas e inserir os dados iniciais no banco de dados.

### 4. Instalar dependências

Primeiro, acesse o diretório do projeto:

```bash
cd bloom-api
```

No terminal, dentro da pasta do projeto, execute:

```bash
poetry install
```

Isso vai instalar todas as dependências definidas no pyproject.toml e poetry.lock.

Após criar as tabelas e instalar as dependências, deve ser executado um script para inserir o plano pré-natal pré-definido no sistema:

```bash
poetry run python -m scripts.inserir_plano_pre_natal_db
```

Isso irá inserir todo o plano que está no arquivo `bloom-api/data/plano_pre_natal.csv`.

### 5. Rodar a aplicação FastAPI

Para iniciar a API, execute:

```bash
poetry run uvicorn main:app --reload
```

main é o nome do arquivo Python onde está a instância da FastAPI (app).

--reload faz o servidor reiniciar automaticamente a cada alteração no código.

### 6. Acessar a API

Após iniciar o servidor, acesse no navegador ou via API client:

```bash
http://localhost:8000
```

Para acessar a documentação interativa automática (Swagger UI):

```bash
http://localhost:8000/docs
```

_Obs.:_ O projeto dispõe de um comando para popular o banco de dados com dados falsos para testes, se precisar, execute:

```bash
poetry run python -m tests.insercao_dados_testes_db
```


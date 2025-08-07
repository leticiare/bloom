# Bloom
![alt text](./media/cover.png)
Bloom é uma plataforma para auxiliar o acompanhamento do pré-natal por parte das gestantes, oferecendo informativos, uma lista de exames, consultas e vacinas necessárias durante cada período do pré-natal, além de um fórum para tirar dúvidas com profissionais de saúde e uma lista de artigos feitos pelos próprios profissionais de saúde

## Como rodar o projeto (API)
### 1. Requisitos

- Python 3.12 
- Poetry instalado (https://python-poetry.org/docs/#installation)


### 2. Instalar dependências

No terminal, dentro da pasta do projeto, execute:

```bash
poetry install
```

Isso vai instalar todas as dependências definidas no pyproject.toml e poetry.lock.

### 3. Rodar a aplicação FastAPI
Para iniciar a API, execute:

```bash
poetry run uvicorn main:app --reload
```
main é o nome do arquivo Python onde está a instância da FastAPI (app).

--reload faz o servidor reiniciar automaticamente a cada alteração no código.

### 4. Acessar a API
Após iniciar o servidor, acesse no navegador ou via API client:

```bash
http://localhost:8000
```
Para acessar a documentação interativa automática (Swagger UI):

```bash
http://localhost:8000/docs
```
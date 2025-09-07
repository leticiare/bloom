from dotenv import load_dotenv

load_dotenv()

from api.v1 import (
    artigos,
    auth,
    check_status,
    consultas,
    exames,
    plano_pre_natal,
    relatorio,
    vacinas,
)
from api.v1.middlewares import FormatadorRespostaHttpMiddleware
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from infra.logger.logger import logger

tags_metadata = [
    {
        "name": "Consultas",
        "description": "Operações relacionadas às consultas da gestante, como agendamento, realização, cancelamento e anotações de observações. Para todas as rotas protegidas, use o token de autenticação no cabeçalho no padrão Bearer {token}.",
    },
    {
        "name": "Vacinas",
        "description": "Operações para gerenciamento das vacinas da gestante. Para todas as rotas protegidas, use o token de autenticação no cabeçalho no padrão Bearer {token}.",
    },
    {
        "name": "Exames",
        "description": "Operações para gerenciamento dos exames da gestante. Para todas as rotas protegidas, use o token de autenticação no cabeçalho no padrão Bearer {token}.",
    },
    {"name": "Checar conexão", "description": "Rota para testar interação com API"},
    {
        "name": "Autenticação",
        "description": "Operações para cadastrar e autenticar usuários gestantes e profissionais. Rotas livres de proteção por token.",
    },
    {
        "name": "Plano Pré-Natal",
        "description": "Operações para obter as informações referetes ao plano Pré Natal da gestante. Para todas as rotas protegidas, use o token de autenticação no cabeçalho no padrão Bearer {token}.",
    },
    {
        "name": "Relatório",
        "description": "Operação para exportar as informações da gestante em formato PDF. Para todas as rotas protegidas, use o token de autenticação no cabeçalho no padrão Bearer {token}.",
    },
    {
        "name": "Artigos Informativos",
        "description": "Gerencia operações relacionadas a artigos informativos, incluindo criação, edição, exclusão e consulta. A rota de consulta está disponível para todos os perfis. As demais rotas são protegidas e acessíveis apenas a profissionais. Para acessar rotas protegidas, inclua o token de autenticação no cabeçalho usando o formato Bearer {token}.",
    },
]


app = FastAPI(
    title="Bloom API",
    description="API dos serviços do sistema Bloom",
    version="1.0.0",
    openapi_tags=tags_metadata,
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(FormatadorRespostaHttpMiddleware)


app.include_router(
    check_status.router,
    prefix="/api/connection",
    tags=["Checar conexão"],
)
app.include_router(exames.router, prefix="/api/gestante/exames", tags=["Exames"])
app.include_router(vacinas.router, prefix="/api/gestante/vacinas", tags=["Vacinas"])
app.include_router(
    consultas.router, prefix="/api/gestante/consultas", tags=["Consultas"]
)
app.include_router(auth.router, prefix="/api/auth", tags=["Autenticação"])
app.include_router(
    plano_pre_natal.router,
    prefix="/api/gestante/plano_pre_natal",
    tags=["Plano Pré-Natal"],
)
app.include_router(
    relatorio.router, prefix="/api/gestante/relatorio", tags=["Relatório"]
)


app.include_router(
    artigos.router,
    prefix="/api/artigos",
    tags=["Artigos Informativos"],
)


@app.on_event("startup")
async def startup_event():
    logger.info("Iniciando API Bloom...")


@app.on_event("shutdown")
async def shutdown_event():
    logger.info("Encerrando API Bloom...")

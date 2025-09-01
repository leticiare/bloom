from api.v1 import auth, check_status, consultas, exames, relatorio, vacinas
from api.v1.middlewares import FormatadorRespostaHttpMiddleware
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from infra.logger.logger import logger

app = FastAPI(
    title="Bloom API",
    description="API dos serviços do sistema Bloom",
    version="1.0.0",
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
    tags=["Check connection"],
)
app.include_router(exames.router, prefix="/api/exames", tags=["Exames"])
app.include_router(vacinas.router, prefix="/api/vacinas", tags=["Vacinas"])
app.include_router(consultas.router, prefix="/api/consultas", tags=["Consultas"])
app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])
app.include_router(relatorio.router, prefix="/api/relatorio", tags=["Relatório"])


@app.on_event("startup")
async def startup_event():
    logger.info("Iniciando API Bloom...")


@app.on_event("shutdown")
async def shutdown_event():
    logger.info("Encerrando API Bloom...")

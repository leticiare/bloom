from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import infra.db.iniciar_db
from infra.logger.logger import logger
from api.v1 import check_status, exames
from api.v1.middlewares import FormatadorRespostaHttpMiddleware

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


@app.on_event("startup")
async def startup_event():
    logger.info("Iniciando API Bloom...")


@app.on_event("shutdown")
async def shutdown_event():
    logger.info("Encerrando API Bloom...")

from starlette.middleware.base import BaseHTTPMiddleware
from fastapi.responses import JSONResponse
from fastapi.requests import Request
from fastapi import HTTPException
import json


class FormatadorRespostaHttpMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Rotas do Swagger
        rotas_ignoradas = ["/docs", "/redoc", "/openapi.json", "/docs/oauth2-redirect"]
        if request.url.path in rotas_ignoradas:
            return await call_next(request)

        try:
            resposta_http = await call_next(request)
<<<<<<< HEAD
=======
            
>>>>>>> telas-dashboard
        except Exception as e:
            resposta = {
                "sucesso": False,
                "dados": None,
                "mensagem": "Erro interno do servidor",
                "codigo_http": 500,
            }
            return JSONResponse(content=resposta, status_code=500)

        corpo = b""
        async for chunk in resposta_http.body_iterator:
            corpo += chunk

        dados = json.loads(corpo.decode())

        if resposta_http.status_code >= 400:
            mensagem = (
                dados.get("detail")
                if isinstance(dados, dict) and "detail" in dados
                else str(dados)
            )
            resposta = {
                "sucesso": False,
                "dados": None,
                "mensagem": mensagem,
                "codigo_http": resposta_http.status_code,
            }
            return JSONResponse(content=resposta, status_code=resposta_http.status_code)

        resposta = {
            "sucesso": True,
            "dados": dados,
            "codigo_http": resposta_http.status_code,
        }
        return JSONResponse(content=resposta, status_code=resposta_http.status_code)

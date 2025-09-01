import json

from fastapi.requests import Request
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware


class FormatadorRespostaHttpMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Rotas do Swagger
        rotas_ignoradas = ["/docs", "/redoc", "/openapi.json", "/docs/oauth2-redirect"]
        if request.url.path in rotas_ignoradas:
            return await call_next(request)

        try:
            resposta_http = await call_next(request)
            
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

        # Ignorar se o tipo de conteúdo não for JSON - Para exportação do pdf
        content_type = resposta_http.headers.get("content-type", "")
        if "application/json" not in content_type:
            # Retorna a resposta original (ex: PDF, HTML, etc)
            return resposta_http

        try:
            dados = json.loads(corpo.decode())
        except json.JSONDecodeError:
            dados = {}

        resposta = {
            "sucesso": True,
            "dados": dados,
            "codigo_http": resposta_http.status_code,
        }
        return JSONResponse(content=resposta, status_code=resposta_http.status_code)

import json
import traceback

from fastapi.requests import Request
from fastapi.responses import JSONResponse, Response
from starlette.middleware.base import BaseHTTPMiddleware

from infra.logger.logger import logger


class FormatadorRespostaHttpMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Rotas do Swagger
        rotas_ignoradas = ["/docs", "/redoc", "/openapi.json", "/docs/oauth2-redirect"]
        if request.url.path in rotas_ignoradas:
            return await call_next(request)

        try:
            resposta_http = await call_next(request)

        except Exception as e:
            # Log completo com traceback para auxiliar depuração
            tb = traceback.format_exc()
            try:
                logger.error(
                    "Erro interno não tratado na requisição %s %s:\n%s",
                    request.method,
                    request.url.path,
                    tb,
                )
            except Exception:
                # Caso o logger falhe por algum motivo, cai para print
                print(f"Erro interno não tratado: {e}\n{tb}")

            resposta = {
                "sucesso": False,
                "dados": None,
                # Retorna a mensagem da exceção para facilitar debugging local
                "mensagem": str(e),
                "codigo_http": 500,
            }
            return JSONResponse(content=resposta, status_code=500)

        corpo = b""
        async for chunk in resposta_http.body_iterator:
            corpo += chunk

        content_type = resposta_http.headers.get("content-type", "")

        if "application/json" not in content_type:
            return Response(
                content=corpo,
                status_code=resposta_http.status_code,
                headers=dict(resposta_http.headers),
                media_type=content_type,
            )

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

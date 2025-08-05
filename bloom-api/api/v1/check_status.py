from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()


@router.get("/")
def check_conection():
    return JSONResponse(
        status_code=200, content={"Response": "Connected to the server."}
    )

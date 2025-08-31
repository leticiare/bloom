import base64
from io import BytesIO
from pathlib import Path

from fastapi import APIRouter, Response
from xhtml2pdf import pisa

router = APIRouter()


@router.get("/relatorio-alternativo")
def exportar_pdf_alternativo():
    try:
        caminho_template = (
            Path(__file__).resolve().parent.parent.parent
            / "templates"
            / "relatorio.html"
        )
        caminho_logo = (
            Path(__file__).resolve().parent.parent.parent
            / "templates"
            / "assets"
            / "logo-bloom.png"
        )

        html_content = caminho_template.read_text(encoding="utf-8")

        with open(caminho_logo, "rb") as f:
            logo_base64 = base64.b64encode(f.read()).decode("utf-8")

        logo_tag = f"data:image/png;base64,{logo_base64}"
        html_content = html_content.replace("{{logo}}", logo_tag)

        # Gera o PDF em memória
        result_file = BytesIO()
        pisa_status = pisa.CreatePDF(
            BytesIO(html_content.encode("UTF-8")),
            dest=result_file,
            encoding="UTF-8",
        )

        if pisa_status.err:
            return Response("Ocorreu um erro ao gerar o PDF.", status_code=500)

        result_file.seek(0)
        pdf_bytes = result_file.read()

        headers = {
            "Content-Disposition": 'attachment; filename="relatorio_xhtml2pdf.pdf"'
        }

        return Response(
            content=pdf_bytes, media_type="application/pdf", headers=headers
        )

    except Exception as e:
        return Response(f"Ocorreu um erro inesperado: {e}", status_code=500)

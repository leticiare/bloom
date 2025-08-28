/app
│
├── /auth    
├── /api                      # Controllers e rotas (View + Controller)
│   ├── /v1
│   │   ├── vacinas.py
│   │   ├── consultas.py
│   │   └── ...
│   └── deps.py               # Dependências globais (ex: get_db, get_current_user)
│
├── /infra                   # Implementações técnicas (db, mensageria, etc.)
│   ├── /db
├   |── /schemas                 # Pydantic (Request/Response DTOs)
|   │   ├── vacina.py
|   │   ├── consulta.py
|   │   └── ..
│   │  
│   ├── session.py
│   └── repositories/
│   │       └── vacina_repo_impl.py
│   ├── /notifications       
│   └── /logging             
│
├── /controllers          # Controladores MVC para cada serviço
│   ├── VacinasController.py
│   ├── ConsultasController.py
│   ├── ExamesController.py
│   ├── ForumController.py
│   ├── ConteudoController.py
│   └── RelatorioController.py
│
├── /models               # Modelos (ORM ou validações de dados)
│   ├── Vacina.js
│   ├── Consulta.js
│   ├── Exame.js
│   ├── PostForum.js
│   ├── Conteudo.js
│   └── Relatorio.js
│
├── /repositories         # Repositórios para acesso a dados (DAO ou ORM)
│   ├── VacinasRepository.py
│   ├── ConsultasRepository.py
│   ├── ExamesRepository.py
│   ├── ForumRepository.py
│   ├── ConteudoRepository.py
│   └── RelatorioRepository.py
│
├── /tests                   # Testes unitários e de integração
│   ├── domain/
│   ├── api/
│   └── infra/
│
├── main.py                  # Entry point FastAPI
└── requirements.txt

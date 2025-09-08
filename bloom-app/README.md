# 🌸 Bloom App 🤰✨

Este projeto é desenvolvido com **Flutter** e pronto para rodar em dispositivos Android e iOS. Aqui você encontrará todas as instruções para configurar, executar e entender a estrutura do projeto.

---
## Sumário
- [Pré-requisitos](#🛠️-pré-requisitos)
- [Configuração do Projeto](#📥-configuração-do-projeto)
- [Como Rodar o Projeto](#📱-como-rodar-o-projeto)
    - [1. Conectando um dispositivo físico](#1-conectando-um-dispositivo-físico)
    - [2. Verifique se o dispositivo foi reconhecido](#2-verifique-se-o-dispositivo-foi-reconhecido)
    - [3. Execute o aplicativo](#3-execute-o-aplicativo)
    - [4. Executando via IDE](#4-executando-via-ide)
- [Estrutura de Pastas](#📂-estrutura-de-pastas)
- [Comandos Úteis do Flutter](#🔧-comandos-úteis-do-flutter)
- [Dicas Extras](#💡-dicas-extras)


## 🛠️ Pré-requisitos

Antes de começar, certifique-se de que possui as seguintes ferramentas instaladas:

- **Flutter SDK**: Versão 3.x.x ou superior. ([Guia de instalação](https://docs.flutter.dev/get-started/install))
- **Editor de Código**: VS Code (recomendado) ou Android Studio.
- **Git**: Para clonar o repositório. ([Guia de instalação](https://git-scm.com/book/pt-br/v2/Começando-Instalando-o-Git))
- **Dispositivo ou Emulador**: Android ou iOS para testar a aplicação.

---

## 📥 Configuração do Projeto

Siga os passos abaixo para rodar o projeto localmente:

```bash
# Clone o repositório
git clone https://github.com/leticiare/bloom.git

# Navegue até a pasta do projeto
cd bloom-app

# Instale as dependências
flutter pub get
```

---

## 📱 Como Rodar o Projeto

### 1. Conectando um dispositivo físico

**Para Android:**

- Ative o modo Desenvolvedor no seu celular:
  - Vá em **Configurações > Sobre o telefone**
  - Toque em **Número da Versão** 7 vezes
- Abra **Opções do Desenvolvedor** e ative **Depuração USB**
- Conecte o celular ao computador via USB
- Marque **Sempre permitir neste computador** no seu dispositivo, se aparecer a mensagem

**Para iOS:**

- Conecte seu iPhone ao computador e autorize o dispositivo
- Certifique-se de que o Xcode está configurado corretamente

### 2. Verifique se o dispositivo foi reconhecido

No terminal, execute:

```
flutter devices
```

Isso exibirá uma lista de dispositivos conectados. Confirme que seu celular ou emulador está na lista.

### 3. Execute o aplicativo

Com o dispositivo conectado, rode:

```
flutter run
```

_⚠️ Se houver mais de um dispositivo conectado, o Flutter perguntará qual usar. Digite o número correspondente._

### 4. Executando via IDE

- VS CODE: pressione F5 ou clique em Run and Debug
- Android Studio: clique no botão Run (ícone de play)

---

## 📂 Estrutura de Pastas

O projeto segue uma arquitetura limpa, organizada por features, garantindo escalabilidade e manutenibilidade.

```bash

lib/
└── src/
    ├── core/                  # Lógica e configurações globais do app
    │   ├── theme/             # Cores, temas (AppColors, AppTheme)
    │   ├── navigation/        # Configuração de rotas (AppRoutes)
    │   └── utils/             # Utilitários globais (constantes, etc.)
    │
    ├── features/              # Pasta principal, contendo cada funcionalidade do app
    │   ├── auth/              # Autenticação (login, cadastro, etc.)
    │   ├── onboarding/        # Onboarding (telas de boas-vindas)
    │   │   ├── data/          # Fontes de dados (API, mocks, serviços)
    │   │   ├── domain/        # Regras de negócio e entidades (modelos)
    │   │   └── presentation/  # UI (telas, widgets, controllers)
    │   └── dashboard_pregnant/# Dashboard da gestante
    │       ├── data/          # Fontes de dados (API, mocks, serviços)
    │       ├── domain/        # Regras de negócio e entidades (modelos)
    │       └── presentation/  # UI (telas, widgets, controllers)
    │
    └── shared/                # Widgets e serviços compartilhados
        ├── services/          # Serviços (AuthService, etc.)
        └── widgets/           # Widgets reutilizáveis (CustomTextField, etc.)
```

---

## 💻 Tecnologias e Pacotes Utilizados

- **Flutter**: Framework principal para o desenvolvimento da UI.
- **Dart**: Linguagem de programação.
- **http**: Chamadas a APIs REST.
- **shared_preferences / flutter_secure_storage**: Armazenamento local de dados e tokens.
- **intl**: Formatação de datas.
- **table_calendar**: Construção do calendário de eventos.
- E outros.

---

## 🔧 Comandos Úteis do Flutter

| Comando             | Função                                                             |
| ------------------- | ------------------------------------------------------------------ |
| `flutter pub get`   | Baixa as dependências do projeto                                   |
| `flutter run`       | Roda o aplicativo no dispositivo conectado                         |
| `flutter doctor`    | Verifica se o Flutter e dependências estão corretamente instalados |
| `flutter clean`     | Limpa arquivos temporários e rebuilda o projeto                    |
| `flutter build apk` | Gera o APK para Android                                            |
| `flutter build ios` | Gera o aplicativo para iOS                                         |

---

## 💡 Dicas Extras

- Sempre mantenha seu Flutter SDK atualizado
- Se tiver problemas com dependências, tente:

```
flutter pub upgrade
```

- Para melhor performance no VS Code, instale as extensões Flutter e Dart
- Leia as mensagens do terminal com atenção, elas constumam indicar exatamente o que precisa ser corrigido

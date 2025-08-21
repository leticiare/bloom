# 🚀 Bloom App

Este projeto é desenvolvido com **Flutter** e pronto para rodar em dispositivos Android e iOS. Aqui você encontrará todas as instruções para configurar, executar e entender a estrutura do projeto.

---

## 🛠 Pré-requisitos

Antes de começar, certifique-se de que você possui as seguintes ferramentas instaladas:

1.  **Flutter SDK**

    - Versão recomendada: 3.x.x ou superior
    - [Guia de instalação](https://flutter.dev/docs/get-started/install)

2.  **Editor de código**

    - Recomendado: [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)

3.  **Git**

    - Necessário para clonar o repositório
    - [Guia de instalação](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

4.  **Dispositivo físico ou emulador**
    - Para testar o aplicativo em Android ou iOS

---

## 📥 Configuração do Projeto

Siga os passos abaixo para configurar o projeto no seu ambiente de desenvolvimento:

1.  **Clone o repositório**
    Abra o terminal e execute:

    ```bash
    git clone https://github.com/leticiare/bloom.git
    ```

2.  **Entre na pasta do projeto**

    ```bash
    cd bloom-app
    ```

3.  **Instale as dependências do projeto**
    ```bash
    flutter pub get
    ```
    _💡 Dica: Esse comando baixa todos os pacotes que o projeto precisa para funcionar corretamente._

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

## 📂 Estrutura do Projeto

TODO: adicionar estrutura do projeto

## 🔧 Comandos Úteis do Flutter

| Comando             | Função                                                             |
| ------------------- | ------------------------------------------------------------------ |
| `flutter pub get`   | Baixa as dependências do projeto                                   |
| `flutter run`       | Roda o aplicativo no dispositivo conectado                         |
| `flutter doctor`    | Verifica se o Flutter e dependências estão corretamente instalados |
| `flutter clean`     | Limpa arquivos temporários e rebuilda o projeto                    |
| `flutter build apk` | Gera o APK para Android                                            |
| `flutter build ios` | Gera o aplicativo para iOS                                         |

## 💡 Dicas Extras

- Sempre mantenha seu Flutter SDK atualizado
- Se tiver problemas com dependências, tente:

```
flutter pub upgrade
```

- Para melhor performance no VS Code, instale as extensões Flutter e Dart
- Leia as mensagens do terminal com atenção, elas constumam indicar exatamente o que precisa ser corrigido

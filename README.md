# Cadastro de Clientes com Consulta de Endereço (ViaCEP)

Aplicativo Flutter moderno e reativo para cadastro completo de clientes com preenchimento automático de endereço via API do ViaCEP, gerenciamento de estado com Provider, persistência local com SharedPreferences e design system Material 3.

---

## 🚀 Funcionalidades

- **CRUD Completo de Clientes**:
  - Listagem com visualização em Cards e Avatares dinâmicos com a inicial do nome.
  - Cadastro de novos clientes com validação rigorosa.
  - Edição de cadastros existentes preenchendo o formulário de forma transparente.
  - Exclusão com diálogo de confirmação (`AlertDialog`) e feedback visual (`SnackBar`).
- **Integração com API ViaCEP**:
  - Sanitização automática de CEPs digitados (suporta números puros ou formatados com máscara).
  - Validação prévia de formato (8 dígitos numéricos) antes de disparar requisições HTTP.
  - Preenchimento automático dos campos de Logradouro, Bairro, Cidade (Localidade) e UF.
  - Permissão para edição manual após o preenchimento automático.
- **Tratamento de Estados Racional e Seguro**:
  - `CepStatus` enum (`inicial`, `carregando`, `sucesso`, `erro`) prevenindo estados inconsistentes na UI.
  - Feedback visual de carregamento (`CircularProgressIndicator` de 16px no `suffixIcon`).
  - Tratamento de exceção customizada `CepNaoEncontradoException` para respostas `erro: true` da API HTTP 200.
- **Persistência Local Automática**:
  - Os cadastros são salvos e carregados automaticamente no dispositivo via `shared_preferences`.
- **UX & Polimento Visual**:
  - Design baseado em **Material 3**.
  - Máscaras de entrada dinâmicas para **Telefone** e **CEP** (`mask_text_input_formatter`).
  - Mensagens de erro inline e SnackBar flutuante.

---

## 🛠️ Arquitetura e Estrutura de Pastas

A estrutura do projeto segue a separação limpa de responsabilidades (Clean Architecture / Feature-based):

```
lib/
├── models/
│   ├── cliente.dart            # Modelo de dados imutável com toMap, fromMap e copyWith
│   └── endereco_via_cep.dart    # Modelo de resposta da API ViaCEP
├── providers/
│   ├── cliente_provider.dart    # Provider global (ChangeNotifier) com CRUD e SharedPreferences
│   └── cep_provider.dart        # Provider efêmero de consulta ao CEP com enum CepStatus
├── services/
│   └── via_cep_service.dart     # Serviço HTTP de consulta ao ViaCEP e CepNaoEncontradoException
├── screens/
│   ├── listagem_screen.dart     # Tela principal de listagem com estado vazio e exclusão
│   └── formulario_screen.dart   # Tela de criação e edição com validações e máscaras
└── utils/
    ├── masks.dart               # Configuradores de máscaras de input (CEP e Telefone)
    └── validators.dart          # Validador de obrigatoriedade, e-mail, telefone e CEP
```

---

## 📦 Pacotes Utilizados

- **[provider](https://pub.dev/packages/provider)**: Gerenciamento de estado reativo e injeção de dependência.
- **[http](https://pub.dev/packages/http)**: Requisições HTTP REST à API do ViaCEP.
- **[uuid](https://pub.dev/packages/uuid)**: Geração de identificadores únicos (UUID v4) para cada cliente.
- **[mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter)**: Máscaras de entrada em tempo real.
- **[shared_preferences](https://pub.dev/packages/shared_preferences)**: Persistência local de dados no dispositivo.

---

## 💻 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK (versão 3.12.0 ou superior)
- Dart SDK 3.0+
- Navegador Google Chrome (para Web) ou Emulador Android/iOS

### Passos para execução:

1. **Clonar o repositório**:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd chappFlutter
   ```

2. **Instalar as dependências**:
   ```bash
   flutter pub get
   ```

3. **Executar a aplicação**:
   - **No Navegador (Web)**:
     ```bash
     flutter run -d chrome
     ```
   - **No Emulador/Dispositivo**:
     ```bash
     flutter run
     ```

4. **Executar a análise de código (Lint)**:
   ```bash
   flutter analyze
   ```

---

## 📝 Commits e GitFlow

O desenvolvimento seguiu os padrões do **GitFlow** com commits semânticos:
- `feat: cria model Cliente com serialização para Map`
- `feat: cria ClienteProvider com operacoes CRUD`
- `feat: adiciona service de consulta ao ViaCEP`
- `feat: cria CepProvider com estados de loading/sucesso/erro`
- `feat: cria tela de listagem de clientes com exclusao`
- `feat: adiciona validadores e mascaras de input`
- `feat: implementa FormularioScreen com busca de CEP e validacoes`
- `feat: adiciona persistencia local SharedPreferences e polimento de UX`

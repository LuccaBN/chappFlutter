# Cadastro de Clientes — chapp_flutter

Aplicativo Flutter para cadastro de clientes com endereço, desenvolvido como desafio
técnico. Permite listar, cadastrar, editar e excluir clientes, com preenchimento
automático de endereço a partir do CEP (integração com a API [ViaCEP](https://viacep.com.br/)).

## Funcionalidades

- Listagem de clientes cadastrados, com estado vazio e exclusão (com confirmação)
- Cadastro e edição em uma única tela de formulário
- Validação de campos obrigatórios (nome, e-mail, telefone, CEP, logradouro, número, bairro, cidade, UF)
- Máscaras de input para CEP e telefone
- Validação de formato do CEP antes de consultar a API
- Busca automática de endereço ao completar o CEP, com feedback visual de carregamento, sucesso e erro
- Campos de endereço preenchidos automaticamente permanecem editáveis
- Persistência em memória durante a execução do app (sem backend)

## Arquitetura

```
lib/
├── models/       # Cliente e EnderecoViaCep — estruturas de dados
├── services/      # ViaCepService — integração HTTP com a API ViaCEP
├── providers/     # ClienteProvider (CRUD em memória) e CepProvider (estados da busca de CEP)
├── screens/       # ListagemScreen e FormularioScreen (criação/edição)
├── utils/         # Validators e Masks — validação e máscaras de input
└── main.dart
```

- **Gerenciamento de estado:** [provider](https://pub.dev/packages/provider), com `ChangeNotifier`.
- `ClienteProvider` é global (registrado em `main.dart`), pois a lista de clientes é
  compartilhada entre as telas.
- `CepProvider` é escopado localmente à `FormularioScreen`, já que o estado de busca de
  CEP só é relevante durante o preenchimento do formulário.
- Estados de carregamento/sucesso/erro são modelados explicitamente via enum
  (`CepStatus`) em vez de flags booleanas soltas.

## Como executar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
(canal stable) e um dispositivo/emulador configurado (Android, iOS, ou um dos alvos
desktop/web habilitados no projeto).

```bash
flutter pub get
flutter run
```

Para rodar os testes:

```bash
flutter test
```

## Stack

- Flutter / Dart
- [provider](https://pub.dev/packages/provider) — gerenciamento de estado
- [http](https://pub.dev/packages/http) — consumo da API ViaCEP
- [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) — máscaras de CEP e telefone
- [uuid](https://pub.dev/packages/uuid) — geração de identificadores dos clientes

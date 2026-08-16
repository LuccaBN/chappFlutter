import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/cliente.dart';
import '../models/endereco_via_cep.dart';
import '../providers/cliente_provider.dart';
import '../providers/cep_provider.dart';
import '../utils/validators.dart';
import '../utils/masks.dart';

class FormularioScreen extends StatelessWidget {
  final Cliente? cliente;
  const FormularioScreen({super.key, this.cliente});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CepProvider(),
      child: _FormularioBody(cliente: cliente),
    );
  }
}

class _FormularioBody extends StatefulWidget {
  final Cliente? cliente;
  const _FormularioBody({this.cliente});

  @override
  State<_FormularioBody> createState() => _FormularioBodyState();
}

class _FormularioBodyState extends State<_FormularioBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _cepController;
  late final TextEditingController _logradouroController;
  late final TextEditingController _numeroController;
  late final TextEditingController _complementoController;
  late final TextEditingController _bairroController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _ufController;

  bool get _modoEdicao => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    _nomeController = TextEditingController(text: c?.nome ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _telefoneController = TextEditingController(text: c?.telefone ?? '');
    _cepController = TextEditingController(text: c?.cep ?? '');
    _logradouroController = TextEditingController(text: c?.logradouro ?? '');
    _numeroController = TextEditingController(text: c?.numero ?? '');
    _complementoController = TextEditingController(text: c?.complemento ?? '');
    _bairroController = TextEditingController(text: c?.bairro ?? '');
    _cidadeController = TextEditingController(text: c?.cidade ?? '');
    _ufController = TextEditingController(text: c?.uf ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  /// Dispara a busca do endereço quando o CEP digitado é válido.
  Future<void> _buscarCep() async {
    final cep = _cepController.text;
    if (!Validators.cepEhValido(cep)) return;

    final cepProvider = context.read<CepProvider>();
    await cepProvider.buscarCep(cep);

    if (!mounted) return;

    if (cepProvider.status == CepStatus.sucesso && cepProvider.endereco != null) {
      _preencherEndereco(cepProvider.endereco!);
    }
  }

  /// Preenche os campos de endereço com o resultado do ViaCEP.
  void _preencherEndereco(EnderecoViaCep endereco) {
    setState(() {
      _logradouroController.text = endereco.logradouro;
      _bairroController.text = endereco.bairro;
      _cidadeController.text = endereco.localidade;
      _ufController.text = endereco.uf;
      if (endereco.complemento.isNotEmpty) {
        _complementoController.text = endereco.complemento;
      }
    });
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final clienteNovo = Cliente(
      id: widget.cliente?.id ?? const Uuid().v4(),
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cep: _cepController.text.trim(),
      logradouro: _logradouroController.text.trim(),
      numero: _numeroController.text.trim(),
      complemento: _complementoController.text.trim().isEmpty
          ? null
          : _complementoController.text.trim(),
      bairro: _bairroController.text.trim(),
      cidade: _cidadeController.text.trim(),
      uf: _ufController.text.trim(),
    );

    final provider = context.read<ClienteProvider>();

    if (_modoEdicao) {
      provider.atualizarCliente(clienteNovo);
    } else {
      provider.adicionarCliente(clienteNovo);
    }

    final mensagem = _modoEdicao
        ? 'Cliente "${clienteNovo.nome}" atualizado com sucesso!'
        : 'Cliente "${clienteNovo.nome}" cadastrado com sucesso!';

    Navigator.pop(context, mensagem);
  }

  /// Retorna o ícone indicador do status da busca de CEP.
  Widget? _buildCepSuffixIcon(CepStatus status) {
    switch (status) {
      case CepStatus.carregando:
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      case CepStatus.sucesso:
        return const Icon(Icons.check_circle, color: Colors.green);
      case CepStatus.erro:
        return const Icon(Icons.error, color: Colors.red);
      case CepStatus.inicial:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar Cliente' : 'Novo Cliente'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome completo *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => Validators.obrigatorio(v, campo: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail *',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone *',
                prefixIcon: Icon(Icons.phone),
              ),
              inputFormatters: [Masks.telefone],
              keyboardType: TextInputType.phone,
              validator: Validators.telefone,
            ),
            const SizedBox(height: 12),
            Consumer<CepProvider>(
              builder: (context, cepProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _cepController,
                      decoration: InputDecoration(
                        labelText: 'CEP *',
                        prefixIcon: const Icon(Icons.location_on),
                        suffixIcon: _buildCepSuffixIcon(cepProvider.status),
                      ),
                      inputFormatters: [Masks.cep],
                      keyboardType: TextInputType.number,
                      validator: Validators.cep,
                      onChanged: (_) => _buscarCep(),
                    ),
                    if (cepProvider.status == CepStatus.erro &&
                        cepProvider.mensagemErro != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 12),
                        child: Text(
                          cepProvider.mensagemErro!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _logradouroController,
              decoration: const InputDecoration(
                labelText: 'Logradouro *',
                prefixIcon: Icon(Icons.home),
              ),
              validator: (v) => Validators.obrigatorio(v, campo: 'Logradouro'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _numeroController,
                    decoration: const InputDecoration(
                      labelText: 'Número *',
                      prefixIcon: Icon(Icons.pin),
                    ),
                    validator: (v) =>
                        Validators.obrigatorio(v, campo: 'Número'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _complementoController,
                    decoration: const InputDecoration(
                      labelText: 'Complemento',
                      prefixIcon: Icon(Icons.info_outline),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bairroController,
              decoration: const InputDecoration(
                labelText: 'Bairro *',
                prefixIcon: Icon(Icons.map),
              ),
              validator: (v) => Validators.obrigatorio(v, campo: 'Bairro'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _cidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade *',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (v) =>
                        Validators.obrigatorio(v, campo: 'Cidade'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _ufController,
                    decoration: const InputDecoration(
                      labelText: 'UF *',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) => Validators.obrigatorio(v, campo: 'UF'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _salvar,
              child: Text(
                _modoEdicao ? 'Salvar Alterações' : 'Cadastrar Cliente',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

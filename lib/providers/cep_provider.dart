import 'package:flutter/foundation.dart';
import '../models/endereco_via_cep.dart';
import '../services/via_cep_service.dart';

enum CepStatus { inicial, carregando, sucesso, erro }

class CepProvider extends ChangeNotifier {
  final ViaCepService _service;

  CepProvider({ViaCepService? service})
      : _service = service ?? ViaCepService();

  CepStatus _status = CepStatus.inicial;
  EnderecoViaCep? _endereco;
  String? _mensagemErro;

  CepStatus get status => _status;
  EnderecoViaCep? get endereco => _endereco;
  String? get mensagemErro => _mensagemErro;

  /// Realiza a busca do CEP informado alterando os estados para [CepStatus].
  Future<void> buscarCep(String cep) async {
    _status = CepStatus.carregando;
    _mensagemErro = null;
    notifyListeners();

    try {
      _endereco = await _service.buscarEnderecoPorCep(cep);
      _status = CepStatus.sucesso;
    } on CepNaoEncontradoException catch (e) {
      _status = CepStatus.erro;
      _mensagemErro = e.message;
      _endereco = null;
    } catch (e) {
      _status = CepStatus.erro;
      _mensagemErro = 'Erro ao consultar o CEP. Verifique sua conexão e tente novamente.';
      _endereco = null;
    } finally {
      notifyListeners();
    }
  }

  /// Reseta o estado do provider para o estado inicial [CepStatus.inicial].
  void resetar() {
    _status = CepStatus.inicial;
    _endereco = null;
    _mensagemErro = null;
    notifyListeners();
  }
}

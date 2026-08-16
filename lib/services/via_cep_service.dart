import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco_via_cep.dart';

/// Exceção lançada quando a API do ViaCEP responde com status 200, porém com a chave `erro: true`.
class CepNaoEncontradoException implements Exception {
  final String message;
  CepNaoEncontradoException([this.message = 'CEP não encontrado.']);

  @override
  String toString() => message;
}

class ViaCepService {
  static const _baseUrl = 'https://viacep.com.br/ws';

  /// Busca os dados de endereço na API do ViaCEP a partir de um [cep].
  /// Lança [CepNaoEncontradoException] se o CEP for válido mas não existir na base de dados.
  /// Lança [Exception] genérica em caso de falhas na requisição HTTP.
  Future<EnderecoViaCep> buscarEnderecoPorCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('$_baseUrl/$cleanCep/json/');
    
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Falha ao conectar à API do ViaCEP. Código: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['erro'] == true || data['erro'] == 'true') {
      throw CepNaoEncontradoException();
    }

    return EnderecoViaCep.fromJson(data);
  }
}

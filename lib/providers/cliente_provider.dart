import 'package:flutter/foundation.dart';
import '../models/cliente.dart';

class ClienteProvider extends ChangeNotifier {
  final List<Cliente> _clientes = [];

  /// Retorna uma lista não modificável dos clientes cadastrados.
  List<Cliente> get clientes => List.unmodifiable(_clientes);

  /// Adiciona um novo cliente e notifica os ouvintes.
  void adicionarCliente(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners();
  }

  /// Atualiza os dados de um cliente existente com base no seu [id].
  void atualizarCliente(Cliente clienteAtualizado) {
    final index = _clientes.indexWhere((c) => c.id == clienteAtualizado.id);
    if (index != -1) {
      _clientes[index] = clienteAtualizado;
      notifyListeners();
    }
  }

  /// Remove um cliente da lista com base no seu [id].
  void removerCliente(String id) {
    final lengthBefore = _clientes.length;
    _clientes.removeWhere((c) => c.id == id);
    if (_clientes.length != lengthBefore) {
      notifyListeners();
    }
  }

  /// Busca um cliente pelo seu [id]. Retorna [null] se não for encontrado.
  Cliente? buscarPorId(String id) {
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

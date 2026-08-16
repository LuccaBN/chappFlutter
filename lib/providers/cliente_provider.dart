import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cliente.dart';

class ClienteProvider extends ChangeNotifier {
  static const _prefsKey = 'clientes_cadastrados';
  final List<Cliente> _clientes = [];

  ClienteProvider() {
    _carregarClientes();
  }

  /// Retorna uma lista não modificável dos clientes cadastrados.
  List<Cliente> get clientes => List.unmodifiable(_clientes);

  /// Carrega os clientes salvos no SharedPreferences.
  Future<void> _carregarClientes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_prefsKey);
      if (data != null && data.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(data);
        _clientes.clear();
        _clientes.addAll(
          decodedList.map((item) => Cliente.fromMap(item as Map<String, dynamic>)),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao carregar clientes do SharedPreferences: $e');
    }
  }

  /// Salva a lista atual de clientes no SharedPreferences.
  Future<void> _salvarClientes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedList = jsonEncode(_clientes.map((c) => c.toMap()).toList());
      await prefs.setString(_prefsKey, encodedList);
    } catch (e) {
      debugPrint('Erro ao salvar clientes no SharedPreferences: $e');
    }
  }

  /// Adiciona um novo cliente, salva no SharedPreferences e notifica a UI.
  void adicionarCliente(Cliente cliente) {
    _clientes.add(cliente);
    _salvarClientes();
    notifyListeners();
  }

  /// Atualiza os dados de um cliente existente e persiste a alteração.
  void atualizarCliente(Cliente clienteAtualizado) {
    final index = _clientes.indexWhere((c) => c.id == clienteAtualizado.id);
    if (index != -1) {
      _clientes[index] = clienteAtualizado;
      _salvarClientes();
      notifyListeners();
    }
  }

  /// Remove um cliente da lista e atualiza o SharedPreferences.
  void removerCliente(String id) {
    final lengthBefore = _clientes.length;
    _clientes.removeWhere((c) => c.id == id);
    if (_clientes.length != lengthBefore) {
      _salvarClientes();
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cliente.dart';
import '../providers/cliente_provider.dart';
import 'formulario_screen.dart';

class ListagemScreen extends StatelessWidget {
  const ListagemScreen({super.key});

  /// Exibe um diálogo de confirmação antes de excluir o cliente.
  void _confirmarExclusao(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Cliente'),
        content: Text('Deseja realmente remover "${cliente.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              context.read<ClienteProvider>().removerCliente(cliente.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cliente "${cliente.nome}" removido.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes Cadastrados'),
        centerTitle: true,
      ),
      body: Consumer<ClienteProvider>(
        builder: (context, clienteProvider, _) {
          final clientes = clienteProvider.clientes;

          if (clientes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum cliente cadastrado',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque no botão "+" para adicionar o primeiro cadastro.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: clientes.length,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      cliente.nome.isNotEmpty ? cliente.nome[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(
                    cliente.nome,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${cliente.cidade} - ${cliente.uf}\n${cliente.telefone}',
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormularioScreen(cliente: cliente),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => _confirmarExclusao(context, cliente),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FormularioScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Cliente'),
      ),
    );
  }
}

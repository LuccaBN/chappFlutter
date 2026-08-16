import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chapp_flutter/main.dart';
import 'package:chapp_flutter/providers/cliente_provider.dart';

void main() {
  Widget buildApp() {
    return ChangeNotifierProvider(
      create: (_) => ClienteProvider(),
      child: const MyApp(),
    );
  }

  testWidgets('Exibe lista vazia e abre o formulario de novo cliente',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Clientes Cadastrados'), findsOneWidget);
    expect(find.text('Nenhum cliente cadastrado'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Novo Cliente'), findsOneWidget);
  });
}

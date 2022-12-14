import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto/gravacao.dart';

import 'Home_page.dart';
import 'cadastro_page.dart';

class DefinirNome extends StatefulWidget {
  const DefinirNome({super.key});

  @override
  State<DefinirNome> createState() => _DefinirNomeState();
}

class _DefinirNomeState extends State<DefinirNome> {
  final nomeArquivo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digite o nome"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: nomeArquivo,
            decoration: const InputDecoration(
              label: Text("Nome"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                validar();
              },
              child: const Text("Escolher música")),
        ],
      ),
    );
  }

  validar() async {
    if (nomeArquivo != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MinhaGravacao(
            nomeArquivo: nomeArquivo.text,
          ),
        ),
      );
    }
  }
}

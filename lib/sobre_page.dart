import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Home_page.dart';
import 'cadastro_page.dart';

class SobrePage extends StatefulWidget {
  const SobrePage({super.key});

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre o app"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
              "O aplicativo simula um karaoque. Ao realizar o login, ou o cadastro, o usuário é apresentado às gravações já efetuadas. Para realizar uma nova gravação, basta clicar nos três risquinhos no canto superior esquerdo, em seguida em nova gravação. Será direcionado a escolha da música de fundo, e tendo escolhida, pode-se iniciar a gravação tocando no batão. Ao finalizar a gravação o usuário será redirecionado à tela de reprodução, onde pode-se ouvir seu karaoque."),
          Text('Por Rafael Wurzius'),
        ],
      ),
    );
  }
}

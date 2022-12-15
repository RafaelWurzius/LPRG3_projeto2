import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home_page.dart';
import 'cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtlr = TextEditingController();
  final _senhaCtlr = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faça seu login"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _emailCtlr,
            decoration: const InputDecoration(
              label: Text("Email"),
            ),
          ),
          TextFormField(
            controller: _senhaCtlr,
            decoration: const InputDecoration(
              label: Text("Senha"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                login();
              },
              child: const Text("Entrar")),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastroPage()));
            },
            child: const Text("Criar Conta"),
          ),
        ],
      ),
    );
  }

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailCtlr.text, password: _senhaCtlr.text);
      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuário não encontrado!")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Senha incorreta!")));
      }
    }
  }
}

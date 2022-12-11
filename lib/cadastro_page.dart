import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/verificacao_page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeCtlr = TextEditingController();
  final _emailCtlr = TextEditingController();
  final _senhaCtlr = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _nomeCtlr,
            decoration: InputDecoration(
              label: Text("Nome completo"),
            ),
          ),
          TextFormField(
            controller: _emailCtlr,
            decoration: InputDecoration(
              label: Text("Email"),
            ),
          ),
          TextFormField(
            controller: _senhaCtlr,
            decoration: InputDecoration(
              label: Text("Senha"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cadastrar();
            },
            child: Text("Cadastrar"),
          ),
        ],
      ),
    );
  }

  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailCtlr.text, password: _senhaCtlr.text);
      if (userCredential != null) {
        userCredential.user!.updateDisplayName(_nomeCtlr.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => verificacaoPage(),
            ),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Senha muito fraca!")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Esse email já foi cadastrado!")));
      }
    }
  }
}

// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/definir_nome.dart';
import 'package:projeto/models/registro.dart';
import 'package:projeto/repositorio/registro_repositorio.dart';
import 'package:projeto/verificacao_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

import 'gravacao.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Future setAudio() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     final file = File(result.files.single.path!);
  //     audioPlayer.setUrl(file.path, isLocal: true);
  //   }
  // }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  final _firebaseAuth = FirebaseAuth.instance;
  String nome = "";
  String email = "";
  @override
  initState() {
    pegarUsuario();
    audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    // setAudio();
  }

  @override
  Widget build(BuildContext context) {
    final tabela = RegistroRepositorio.tabela;

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(nome),
                accountEmail: Text(email),
              ),
              ListTile(
                dense: true,
                title: Text("Home"),
                trailing: Icon(Icons.home_outlined),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                title: Text("Nova gravação"),
                trailing: Icon(Icons.add),
                onTap: () {
                  gravar();
                },
              ),
              ListTile(
                dense: true,
                title: Text("Sair"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () {
                  sair();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Home Page"),
        ),
        body: ListView.separated(
            itemBuilder: (BuildContext context, int registro) {
              return ListTile(
                leading: Image.asset(
                  tabela[registro].icone,
                  width: 50,
                  height: 50,
                ),
                title: Text(tabela[registro].nome),
              );
            },
            padding: EdgeInsets.all(16),
            separatorBuilder: (_, __) => Divider(),
            itemCount: tabela.length)

        //     Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Text(nome, textAlign: TextAlign.center),
        //   ],
        // )
        );
  }

  pegarUsuario() async {
    User? usuario = await _firebaseAuth.currentUser;
    if (usuario != null) {
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
      });
    }
  }

  sair() async {
    await _firebaseAuth.signOut().then(
          (user) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => verificacaoPage(),
            ),
          ),
        );
  }

  gravar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const DefinirNome()));
  }
}

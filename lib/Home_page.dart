// @dart=2.9
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/definir_nome.dart';
import 'package:projeto/helpers/database_helper.dart';
import 'package:projeto/models/registro.dart';
import 'package:projeto/sobre_page.dart';
import 'package:projeto/verificacao_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'player.dart';
import 'gravacao.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_collection_literals, deprecated_member_use
  List<Registro> listaDeRegistros = List<Registro>();
  List<Todo> listaDeTodos = List<Todo>();

// referencia nossa classe single para gerenciar o banco de dados
  final dbHelper = DatabaseHelper.instance;

  final audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

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
    buscartodos();
    getAnimais();
  }

  @override
  Widget build(BuildContext context) {
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
                title: Text("Sobre"),
                trailing: Icon(Icons.person),
                onTap: () {
                  sobrear();
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
          title: Text(
            "Suas gravações",
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final Registro obj = listaDeRegistros[index];

            final Todo img = listaDeTodos[index + 1];

            return ListTile(
              leading: Image.network(
                // 'images/dog.png',
                // img.avatar.toString(),
                img.avatar.toString(),
                width: 50,
                height: 50,
              ),
              title: Text(obj.nome.toString()),
              trailing: ElevatedButton(
                child: Icon(Icons.arrow_right),
                onPressed: () {
                  reproduzir(obj.nome, obj.audio, obj.musica);
                },
              ),
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, __) => Divider(),
          itemCount: listaDeRegistros.length,
        ));
  }

  reproduzir(String nome, String audio, String musica) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Player(
                  audioPath: audio,
                  musicaPath: musica,
                  nomeArquivo: nome,
                  jaSalvo: true,
                )));
  }

  pegarUsuario() async {
    User usuario = await _firebaseAuth.currentUser;
    if (usuario != null) {
      setState(() {
        nome = usuario.displayName;
        email = usuario.email;
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

  sobrear() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SobrePage()));
  }

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Audio 1',
      DatabaseHelper.columnAudio:
          '/data/user/0/com.example.projeto/cache/audio',
      DatabaseHelper.columnMusica:
          '/data/user/0/com.example.projeto/cache/file_picker/Dance Macabre with lyrics'
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Audio 2',
      DatabaseHelper.columnAudio:
          '/data/user/0/com.example.projeto/cache/audio',
      DatabaseHelper.columnMusica:
          '/data/user/0/com.example.projeto/cache/file_picker/Dance Macabre with lyrics',
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void buscartodos() async {
    List registroRecuperados = await dbHelper.listarRegistros(); //1
    // ignore: deprecated_member_use, prefer_collection_literals
    List<Registro> temporaria = List<Registro>(); //2

    //3
    for (var item in registroRecuperados) {
      Registro r = Registro.fromMap(item);
      temporaria.add(r);
    }

    //4
    setState(() {
      listaDeRegistros = temporaria;
    });
    temporaria = null;
  }

  void getAnimais() {
    Uri uri =
        Uri.https('6374e1fc08104a9c5f8c1820.mockapi.io', '/api/v1/animais/');
    final future = http.get(uri);

    future.then((response) {
      if (response.statusCode == 200) {
        print('Página carregada!');

        var lista = json.decode(response.body) as List; //1

        List<Todo> animaisTemp = List<Todo>(); //2

        //3
        for (var item in lista) {
          Todo a = Todo.fromJason(item);

          animaisTemp.add(a);
        }

        //4
        setState(() {
          listaDeTodos = animaisTemp;
        });
      } else {
        print('Problema!');
      }
    });
  }
}

class Todo {
  final String id;
  final String avatar;

  Todo(this.id, this.avatar);

  factory Todo.fromJason(Map json) {
    return Todo(json['id'], json['avatar']);
  }
}

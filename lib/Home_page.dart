// @dart=2.9
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/definir_nome.dart';
import 'package:projeto/helpers/database_helper.dart';
import 'package:projeto/models/animais.dart';
import 'package:projeto/models/registro.dart';
import 'package:projeto/repositories/animal_repository.dart';
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

  // DatabaseHelper db = DatabaseHelper();
  // List<Registro> registros = <Registro>[]; //diferente dele

// referencia nossa classe single para gerenciar o banco de dados
  final dbHelper = DatabaseHelper.instance;

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

    // Registro r1 = Registro(
    //     1,
    //     'Audio 1',
    //     '/data/user/0/com.example.projeto/cache/audio',
    //     '/data/user/0/com.example.projeto/cache/file_picker/Dance Macabre with lyrics');

    // db.insertRegistro(r1);
    // Registro r2 = Registro(
    //     2,
    //     'Audio 2',
    //     '/data/user/0/com.example.projeto/cache/audio',
    //     '/data/user/0/com.example.projeto/cache/file_picker/Dance Macabre with lyrics');
    // db.insertRegistro(r1);

    // db.getRegistros().then((lista) {
    //   print(lista);
    // });

    // db.getRegistros().then((lista) {
    //   setState(() {
    //     registros = lista;
    //   });
    // });

    buscartodos();
    getAnimais();
  }

  @override
  Widget build(BuildContext context) {
    // final tabela = RegistroRepositorio.tabela;

    // final numeroDeRegistros = dbHelper.queryRowCount();

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(nome),
                accountEmail: Text(email),
              ),
              // ListTile(
              //   dense: true,
              //   title: Text("Mostra animais"),
              //   trailing: Icon(Icons.circle),
              //   onTap: () {
              //     getAnimais();
              //     // final Todo obj1 = listaDeTodos[1];
              //     // print(
              //     //     '------------------------------------------Testando essa bosta: ' +
              //     //         obj1.avatar);

              //     // animais.todos.forEach((element) {
              //     //   var todo = Todo.fromJason(element);

              //     //   print('Caminho da imagem: ' +
              //     //       todo.avatar +
              //     //       '. ID do registro: ' +
              //     //       todo.id);
              //     // });
              //   },
              // ),
              // ListTile(
              //   dense: true,
              //   title: Text("Excluir"),
              //   trailing: Icon(Icons.home_outlined),
              //   onTap: () {
              //     _delete();
              //   },
              // ),
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
        body:
            // Column(
            //   children: <Widget>[
            //     Expanded(
            //         child: ListView.builder(
            //       itemCount: listaDeRegistros.length,
            //       itemBuilder: (context, index) {
            //         final Registro obj = listaDeRegistros[index];
            //         return Card(
            //           child: ListTile(
            //             title: Text(obj.nome),
            //             subtitle: Text(obj.musica),
            //           ),
            //         );
            //       },
            //     ))
            //   ],
            // )
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     ElevatedButton(
            //       child: Text(
            //         'Inserir dados',
            //         style: TextStyle(fontSize: 20),
            //       ),
            //       onPressed: () {
            //         _insert();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: Text(
            //         'Consultar dados',
            //         style: TextStyle(fontSize: 20),
            //       ),
            //       onPressed: () {
            //         _query();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: Text(
            //         'Atualizar dados',
            //         style: TextStyle(fontSize: 20),
            //       ),
            //       onPressed: () {
            //         _update();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: Text(
            //         'Deletar dados',
            //         style: TextStyle(fontSize: 20),
            //       ),
            //       onPressed: () {
            //         _delete();
            //       },
            //     ),
            //   ],
            // ),

            //------------------------------------------------------------
            ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final Registro obj = listaDeRegistros[index];

            final Todo img = listaDeTodos[index + 1];

            print('-----------------------------Lista de todos: id:' +
                listaDeTodos[1].avatar.toString());

            //---------------------
            // Uri uri = Uri.https(
            //     '6374e1fc08104a9c5f8c1820.mockapi.io', '/api/v1/animais/');
            // final future = http.get(uri);

            // Todos minhaLista;

            // future.then((response) {
            //   // if (response.statusCode == 200) {
            //   // print('Página carregada!');
            //   // print(json.decode(response.body));

            //   var lista = json.decode(response.body) as List;

            //   minhaLista = Todos(lista);

            //   minhaLista.todos[1]['avatar'].toString(); //!!!!!!!!!!!!!!!!!!

            //   // print(minhaLista.todos[1]);
            //   // print(lista);
            //   // return minhaLista;

            //   // ACHO Q EU NÃO PRECISO DISSO
            //   // minhaLista.todos.forEach((element) {
            //   //   var todo = Todo.fromJason(element);

            //   //   print('Caminho da imagem: ' +
            //   //       todo.avatar +
            //   //       '. ID do registro: ' +
            //   //       todo.id);
            //   // });
            //   // } else {
            //   //   print('Problema!');
            //   // }
            // });
            //---------------------
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
              // onTap: printar(),
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, __) => Divider(),
          itemCount: listaDeRegistros.length,
        )
//------------------------------------------------------------
        //     Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Text(nome, textAlign: TextAlign.center),
        //   ],
        // )
        );
  }

  // printar() {
  //   print("Oi");
  // }

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
  // reproduzir(String nome, String audio, String musica) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => Player(
  //                 audioPath: audio,
  //                 musicaPath: musica,
  //                 nomeArquivo: nome,
  //               )));
  // }

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
    print('=================================inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('=================================query all rows:');
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
    print('=================================updated $rowsAffected row(s)');
  }

  //deleta sempre o ultimo id, ultimo registro
  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print(
        '=================================deleted $rowsDeleted row(s): row $id');
  }

  void buscartodos() async {
    List registroRecuperados = await dbHelper.listarRegistros(); //1

    print(
        '=====================================Todas os registros de registros Recuperados:');
    registroRecuperados.forEach((print));

    // ignore: deprecated_member_use, prefer_collection_literals
    List<Registro> temporaria = List<Registro>(); //2

    //3
    for (var item in registroRecuperados) {
      Registro r = Registro.fromMap(item);
      print('Registro #: id:' + r.id.toString());
      temporaria.add(r);
    }

    //4
    setState(() {
      listaDeRegistros = temporaria;
    });

    // print(
    //     '=====================================Todas os registros de listaDeRegistros:');
    // listaDeRegistros.forEach((print));
    temporaria = null;
  }

  void getAnimais() {
    Uri uri =
        Uri.https('6374e1fc08104a9c5f8c1820.mockapi.io', '/api/v1/animais/');
    final future = http.get(uri);

    future.then((response) {
      if (response.statusCode == 200) {
        print('Página carregada!');
        // print(json.decode(response.body));

        var lista = json.decode(response.body) as List; //1

        List<Todo> animaisTemp = List<Todo>(); //2

        //3
        for (var item in lista) {
          Todo a = Todo.fromJason(item);
          // print('----------------------Todo #: id:' + a.avatar.toString());
          animaisTemp
              .add(a); //eu tinha comentado isso aqui, rever os ultimos passos
        }

        //4
        setState(() {
          listaDeTodos = animaisTemp;
        });

        // print('-----------------------------Lista de todos: id: ' +
        //     listaDeTodos[1].avatar.toString());

        // var minhaLista = Todos(lista);

        // print(minhaLista.todos[1]);
        // print(lista);
        // return minhaLista;

        // List<Todo> registros;

        // ACHO Q EU NÃO PRECISO DISSO
        // lista.forEach((element) {
        //   var todo = Todo.fromJason(element);
        //   registros.add(todo);

        // print('Caminho da imagem: ' +
        //     todo.avatar +
        //     '. ID do registro: ' +
        //     todo.id);
        // });
        // print(
        //     '----------------------------------------Testabdo essa merda agora: ' +
        //         registros[1].toString());
      } else {
        print('Problema!');
      }
    });
  }
}

// class Todos {
//   List todos = [];

//   Todos(this.todos);
// }

class Todo {
  final String id;
  final String avatar;

  Todo(this.id, this.avatar);

  factory Todo.fromJason(Map json) {
    return Todo(json['id'], json['avatar']);
  }
}

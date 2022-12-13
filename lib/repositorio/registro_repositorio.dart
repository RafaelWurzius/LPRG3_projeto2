import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../models/registro.dart';

class ContaRepositorio extends ChangeNotifier {
  late Database db;
  List<Registro> _registro = [];
}


// import 'package:projeto/models/registro.dart';

// class RegistroRepositorio {
//   static List<Registro> tabela = [
//     Registro(
//         icone: 'images/dog.png',
//         nome: 'Registro 1',
//         gravacao: '/data/user/0/com.example.projeto/cache/audio',
//         musica:
//             '/data/user/0/com.example.projeto/cache/file_picker/Dance Macabre with lyrics'),
//     Registro(
//         icone: 'images/dog.jpg',
//         nome: 'Registro 2',
//         gravacao: '/data/user/0/com.example.projeto/cache/audio',
//         musica:
//             '/data/user/0/com.example.projeto/cache/file_picker/Dance Macabre with lyrics'),
//     Registro(
//         icone: 'images/dog.png',
//         nome: 'Registro 3',
//         gravacao: '/data/user/0/com.example.projeto/cache/audio',
//         musica:
//             '/data/user/0/com.example.projeto/cache/file_picker/Dance Macabre with lyrics'),
//   ];
// }

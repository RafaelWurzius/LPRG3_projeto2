// import 'package:flutter/cupertino.dart';
// import 'package:sqflite/sqflite.dart';

// import '../models/registro.dart';

// class ContaRepositorio extends ChangeNotifier {
//   late Database db;
//   List<Registro> _registro = [];
// }

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

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:projeto/constants.dart';
// import 'package:projeto/models/comment.dart';
import 'package:projeto/models/animais.dart';

class AnimalRepository extends ChangeNotifier {
  final List<Animal> _animais = [];

  UnmodifiableListView<Animal> get animais =>
      UnmodifiableListView<Animal>(_animais);

  AnimalRepository() {
    loadAnimais();
  }

  // Future<bool> addComment(Game game, Comment comment) async {
  //   final url = Uri.parse('$baseApi/games/${game.id}/comments');

  //   final response = await http.post(url, body: {
  //     'gameId': game.id.toString(),
  //     'text': comment.text,
  //     'date': comment.date.toString(),
  //   });

  //   if (response.statusCode == 201) {
  //     game.comments.add(comment);
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }

  Future<void> loadAnimais() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseApi/animais'),
          )
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final animaisList = jsonDecode(response.body) as List;

        for (var animalItem in animaisList) {
          _animais.add(
            Animal.fromJson(animalItem),
          );
        }
        notifyListeners();
        // await loadComments();
      }
    } on HttpException catch (error) {
      debugPrint('Erro ao conectar a API: $error');
    } on TimeoutException {
      debugPrint('Timeout excedido ao conectar a API!');
    }
    print(
        "===================================Chegou aqui!================================");
    print(_animais);
  }

  // Future<void> loadComments() async {
  //   for (var game in _games) {
  //     final resp = await http.get(
  //       Uri.parse('$baseApi/games/${game.id}/comments'),
  //     );
  //     if (resp.statusCode == 200) {
  //       final comments = jsonDecode(resp.body) as List;
  //       for (var comment in comments) {
  //         game.comments.add(
  //           Comment(
  //             text: comment['text'] as String,
  //             date: DateTime.parse(comment['date']),
  //           ),
  //         );
  //         notifyListeners();
  //       }
  //     }
  //   }
  // }
}

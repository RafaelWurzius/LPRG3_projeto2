import 'dart:async';
import 'dart:io';
import 'package:projeto/models/registro.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper = DatabaseHelper();
  static Database _database = _database;

//usada para definir as colunas da tabeala
  String registroTable = 'registro';
  String colId = 'id';
  String colNome = 'nome';
  String colAudio = 'audio';
  String colMusica = 'musica';

  //construtor nomeado para criar instância da classe
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      // executado somente uma vez
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'registros.db';

    var contatosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contatosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $registroTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colNome TEXT, $colAudio TEXT, $colMusica TEXT)');
  }

//Incluir um objeto registro no banco de dados
  Future<int> insertRegistro(Registro registro) async {
    Database db = await this.database;

    var resultado = await db.insert(registroTable, registro.toMap());

    return resultado;
  }

//retorna um registro pelo id
  Future<Registro?> getRegistro(int id) async {
    Database db = await this.database;

    List<Map<String, dynamic>> maps = await db.query(registroTable,
        columns: [colId, colNome, colAudio, colMusica],
        where: "$colId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Registro.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //Atualizar o objeto registro e salva no banco de dados
  Future<int> updateRegistro(Registro registro) async {
    var db = await this.database;

    var resultado = await db.update(registroTable, registro.toMap(),
        where: '$colId = ?', whereArgs: [registro.id]);

    return resultado;
  }

  //Deletar um objeto registro do banco de dados
  Future<int> deleteRegistro(int id) async {
    var db = await this.database;

    int resultado =
        await db.delete(registroTable, where: "$colId = ?", whereArgs: [id]);

    return resultado;
  }

//Obtem o número de objetos registro no banco de dados
  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $registroTable');

    int? resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}

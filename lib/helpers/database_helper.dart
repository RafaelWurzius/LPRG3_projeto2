// @dart=2.9

//TENTATIVA 1
// import 'dart:async';
// import 'dart:io';
// import 'package:projeto/models/registro.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static DatabaseHelper _databaseHelper = DatabaseHelper();
//   static Database _database = _database;

// //usada para definir as colunas da tabeala
//   String registroTable = 'registro';
//   String colId = 'id';
//   String colNome = 'nome';
//   String colAudio = 'audio';
//   String colMusica = 'musica';

//   //construtor nomeado para criar instância da classe
//   DatabaseHelper._createInstance();

//   factory DatabaseHelper() {
//     if (_databaseHelper == null) {
//       // executado somente uma vez
//       _databaseHelper = DatabaseHelper._createInstance();
//     }
//     return _databaseHelper;
//   }

//   Future<Database> get database async {
//     if (_database == null) {
//       _database = await initializeDatabase();
//     }
//     return _database;
//   }

//   Future<Database> initializeDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = directory.path + 'registros.db';

//     var contatosDatabase =
//         await openDatabase(path, version: 1, onCreate: _createDb);
//     return contatosDatabase;
//   }

//   void _createDb(Database db, int newVersion) async {
//     await db.execute(
//         'CREATE TABLE $registroTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
//         '$colNome TEXT, $colAudio TEXT, $colMusica TEXT)');
//   }

// //Incluir um objeto registro no banco de dados
//   Future<int> insertRegistro(Registro registro) async {
//     Database db = await this.database;

//     var resultado = await db.insert(registroTable, registro.toMap());

//     return resultado;
//   }

// //retorna um registro pelo id
//   Future<Registro?> getRegistro(int id) async {
//     Database db = await this.database;

//     List<Map<String, dynamic>> maps = await db.query(registroTable,
//         columns: [colId, colNome, colAudio, colMusica],
//         where: "$colId = ?",
//         whereArgs: [id]);

//     if (maps.length > 0) {
//       return Registro.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }

//   Future<List<Registro>> getRegistros() async {
//     Database db = await this.database;

//     var resultado = await db.query(registroTable);

//     List<Registro> lista = resultado.isNotEmpty
//         ? resultado.map((c) => Registro.fromMap(c)).toList()
//         : [];
//     return lista;
//   }

//   //Atualizar o objeto registro e salva no banco de dados
//   Future<int> updateRegistro(Registro registro) async {
//     var db = await this.database;

//     var resultado = await db.update(registroTable, registro.toMap(),
//         where: '$colId = ?', whereArgs: [registro.id]);

//     return resultado;
//   }

//   //Deletar um objeto registro do banco de dados
//   Future<int> deleteRegistro(int id) async {
//     var db = await this.database;

//     int resultado =
//         await db.delete(registroTable, where: "$colId = ?", whereArgs: [id]);

//     return resultado;
//   }

// //Obtem o número de objetos registro no banco de dados
//   Future<int?> getCount() async {
//     Database db = await this.database;
//     List<Map<String, dynamic>> x =
//         await db.rawQuery('SELECT COUNT (*) from $registroTable');

//     int? resultado = Sqflite.firstIntValue(x);
//     return resultado;
//   }

//   Future close() async {
//     Database db = await this.database;
//     db.close();
//   }
// }
//TENTATIVA 2
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static final _databaseName = "ExemploDB.db";
//   static final _databaseVersion = 1;
//   static final table = 'contato';
//   static final columnId = '_id';
//   static final columnNome = 'nome';
//   static final columnIdade = 'idade';
//   // torna esta classe singleton
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//   // tem somente uma referência ao banco de dados
//   static Database _database = DatabaseHelper._database;

//   Future<Database> get database async {
//     if (_database != null) return _database;
//     // instancia o db na primeira vez que for acessado
//     _database = await _initDatabase();
//     return _database;
//   }

//   // abre o banco de dados e o cria se ele não existir
//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     return await openDatabase(path,
//         version: _databaseVersion, onCreate: _onCreate);
//   }

//   // Código SQL para criar o banco de dados e a tabela
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $table (
//             $columnId INTEGER PRIMARY KEY,
//             $columnNome TEXT NOT NULL,
//             $columnIdade INTEGER NOT NULL
//           )
//           ''');
//   }

//   // métodos Helper
//   //----------------------------------------------------
//   // Insere uma linha no banco de dados onde cada chave
//   // no Map é um nome de coluna e o valor é o valor da coluna.
//   // O valor de retorno é o id da linha inserida.
//   Future<int> insert(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(table, row);
//   }

//   // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
//   // uma lista de valores-chave de colunas.
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     Database db = await instance.database;
//     return await db.query(table);
//   }

//   // Todos os métodos : inserir, consultar, atualizar e excluir,
//   // também podem ser feitos usando  comandos SQL brutos.
//   // Esse método usa uma consulta bruta para fornecer a contagem de linhas.
//   Future<int?> queryRowCount() async {
//     Database db = await instance.database;
//     return Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM $table'));
//   }

//   // Assumimos aqui que a coluna id no mapa está definida. Os outros
//   // valores das colunas serão usados para atualizar a linha.
//   Future<int> update(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row[columnId];
//     return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//   }

//   // Exclui a linha especificada pelo id. O número de linhas afetadas é
//   // retornada. Isso deve ser igual a 1, contanto que a linha exista.
//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//   }
// }
//TENTATIVA 3
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'my_table';

  static final columnId = '_id';
  static final columnName = 'name';
  // static final columnAge = 'age';
  static final columnAudio = 'audio';
  static final columnMusica = 'musica';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAudio TEXT NOT NULL,
            $columnMusica TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  listarRegistros() async {
    Database db = await instance.database;
    String sql = "SELECT * FROM $table";

    List listaRegistros = await db.rawQuery(sql);
    return listaRegistros;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

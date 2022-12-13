// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DB {
//   DB._();
//   static final DB instance = DB._();

//   static Database? _database;

//   get database async {
//     if (_database != null) return _database;

//     return await _initDatabase();
//   }

//   _initDatabase() async {
//     return await openDatabase(
//       join(await getDatabasesPath(), 'karaoque.db'),
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   _onCreate(db, version) async {
//     await db.execute(_gravacoes);
//     await db.insert('gravacoes', {'nome': ''});
//   }

//   String get _gravacoes => '''
//   CREATE TABLE gravacoes(
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     nome TEXT,
//     audio TEXT,
//     musica TEXT
//   )
//   ''';
// }

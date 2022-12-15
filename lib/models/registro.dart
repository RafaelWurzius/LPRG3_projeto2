// @dart=2.9
class Registro {
  int _id;
  String _nome;
  String _audio;
  String _musica;

  Registro(this._id, this._nome, this._audio, this._musica);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': _id,
      'nome': _nome,
      'audio': _audio,
      'musica': _musica
    };
    return map;
  }

  Registro.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._nome = map['name'];
    this._audio = map['audio'];
    this._musica = map['musica'];
  }

  int get id => _id;

  set id(int value) => _id = value;

  String get nome => _nome;
  set nome(String value) => _nome = value;

  String get audio => _audio;
  set audio(String value) => _audio = value;

  String get musica => _musica;
  set musica(String value) => _musica = value;
}

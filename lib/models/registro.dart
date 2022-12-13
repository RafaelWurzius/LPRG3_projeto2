class Registro {
  int id = 0;
  String nome = '';
  String audio = '';
  String musica = '';

  Registro(
    this.id,
    this.nome,
    this.audio,
    this.musica,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nome': nome,
      'audio': audio,
      'musica': musica
    };
    return map;
  }

  Registro.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    audio = map['audio'];
    musica = map['musica'];
  }
}

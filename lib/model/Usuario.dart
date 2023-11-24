import 'dart:core';

class Usuario {
  // Atributos
  String _nome;
  String _email;
  String _senha;
  //String _fotoPerfil;

  // Construtor com parâmetros
  Usuario(
      this._nome,
      this._email,
      this._senha,
      //this._fotoPerfil
      );

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
    };
    return map;
  }


  // Getters and Setters
  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  /*String get fotoPerfil => _fotoPerfil;

  set fotoPerfil(String value) {
  _fotoPerfil = value;
  }*/

}

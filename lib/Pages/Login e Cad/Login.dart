
import '../HomePage/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/Usuario.dart';
import 'CadUser.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario("", email, senha);

        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o E-mail utilizando @";
      });
    }
  }

  _logarUsuario( Usuario usuario ) async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );

    }).catchError((error){

      setState(() {
        _mensagemErro = "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
      });

    });

  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  static const primaryColor = Colors.black; //aqui
  static const secondaryColor = (0xff25d366);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, //aqui

      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "img/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),

               Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      _validarCampos();
                    },
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),

                    ),
                    style: ElevatedButton.styleFrom(

                      primary: Color(secondaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),

                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? Tudo bem! Cadastre-se aqui!",
                      style: TextStyle(
                        color: Color(secondaryColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CadUser()));
                    },
                  ),
                ),
                

                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
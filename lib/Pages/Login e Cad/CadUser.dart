import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon_unipac/Pages/HomePage/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/Usuario.dart';


class CadUser extends StatefulWidget {
  const CadUser({super.key});

  @override
  State<CadUser> createState() => _CadUserState();
}

class _CadUserState extends State<CadUser> {
  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerFotoPerfil = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length >= 6) {
          setState(() {
            _mensagemErro = "";
          });

          Usuario newUser = Usuario(nome, email, senha);

          // Move a chamada para _cadastrarUsuario para o final do método
          _cadastrarUsuario(newUser);
        } else {
          setState(() {
            _mensagemErro = "Preencha a Senha! Senha deve conter mais de 6 caracteres.";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o E-mail usando o @";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }
  }

  _cadastrarUsuario(Usuario newUser) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
      email: newUser.email,
      password: newUser.senha,
    )
        .then((firebaseUser) {

          //salvar dados do usuário
          FirebaseFirestore db = FirebaseFirestore.instance;
          User? user = FirebaseAuth.instance.currentUser;
          db.collection("usuarios")
          .doc(user?.uid)
          .set(newUser.toMap());
      
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage())
          );
          
    }).catchError((onError) {
      setState(() {
        _mensagemErro = "Erro ao cadastrar usuário: $onError";
      });
    });
  }


  static const primaryColor = Colors.black;
  static const secondaryColor = (0xff25d366);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Cadastro"),
        backgroundColor: Color(secondaryColor),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    "img/cadastroicon.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerFotoPerfil,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "URL para foto de perfil",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                  obscureText: true,
                  autofocus: true,
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
                      //chamada de método ao pressionar botão
                      _validarCampos();
                    },
                    child: Text(
                      "Cadastrar",
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
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(color: Colors.red, fontSize: 20),
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

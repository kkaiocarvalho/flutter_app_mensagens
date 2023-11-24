import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_unipac/Utils/iconUtil.dart';

import '../../../../model/Usuario.dart';


class SettingsProfile extends StatelessWidget {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerFoto = TextEditingController();

  Color primaryColor = const Color(0xff25d366);


  _atualizarNomePerfil(BuildContext context) async {
    String novoNome = _controllerNome.text;
    String novaFoto = _controllerFoto.text;

    // Verificar se o usuário está autenticado
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Atualizar o nome no Firebase Authentication
        await user.updateProfile(displayName: novoNome);
        await user.updateProfile(photoURL: novaFoto);

        // Atualizar o nome no Firestore
        FirebaseFirestore.instance.collection("usuarios").doc(user.uid).update({
          "nome": novoNome,
          "fotoPerfil": novaFoto,
        });

        // Navegar de volta à tela anterior ou à tela de perfil
        Navigator.pop(context);
      } catch (error) {
        print("Erro ao atualizar nome: $error");
        // Tratar erros, se necessário
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text ("Perfil"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[ // Adicione a lista de widgets dentro do Column
            Image.network(_controllerFoto.text, width: 300,),
            Text(
              "Mude sua foto ou seu nome!",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17, fontStyle: FontStyle.normal, color: Colors.black,
              ),
            ),


            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _controllerFoto,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "URL da nova foto",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
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

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                onPrimary: Colors.white,
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,

                ),
              ),
              onPressed: () {
                _atualizarNomePerfil(context);

              },
              child: Text("Salvar"),

            ),
          ],
        ),
      ),
    );



  }
}








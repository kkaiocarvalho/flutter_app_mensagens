import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddContacts extends StatefulWidget {
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  Color primaryColor = const Color(0xff25d366);
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerFotoPerfil = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();


  // Função para adicionar contato ao Firestore
  void adicionarContato() async {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String fotoPerfil = _controllerFotoPerfil.text;

    if (nome.isNotEmpty && email.isNotEmpty && fotoPerfil.isNotEmpty) {
      try {
        // Adiciona o novo contato ao Firestore
        await FirebaseFirestore.instance.collection('contacts').add({
          'nameOfPerson': nome,
          'email': email,
          'urlImage': fotoPerfil,
          // Adicione outros campos conforme necessário
        });

        // Limpa os controladores após adicionar o contato
        _controllerNome.clear();
        _controllerEmail.clear();
        _controllerFotoPerfil.clear();

        // Navega de volta para a tela anterior
        Navigator.pop(context);

      } catch (e) {
        print('Erro ao adicionar contato: $e');
      }
    } else {
      print('Preencha todos os campos antes de salvar o contato.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Novo Contato"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(width: 0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "img/cadastroicon.png",
              width: 200,
            ),
            Text(
              "Adicionando Contato:",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.normal,
                color: Colors.black,
              ),
            ),


            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _controllerEmail,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "Email do Contato",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  icon: Icon(Icons.alternate_email, color: primaryColor,),

                ),
              ),
            ),


            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                onPrimary: Colors.white,
                fixedSize: Size.fromHeight(80),
                textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                adicionarContato();
              },
              child: Text("Salvar Contato"),
            ),
          ],
        ),
      ),
    );
  }
}

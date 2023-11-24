import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_unipac/Pages/AddContacts/AddContacts.dart';
import 'package:hackathon_unipac/Pages/HomePage/AppBar/appbar.dart';
import 'package:hackathon_unipac/Pages/HomePage/ContactCard/ContactCard.dart';
import 'package:hackathon_unipac/model/Contact.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _emailUsuario = "";
  List<Contact> _contactList = [];

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    if (usuarioLogado != null) {
      setState(() {
        _emailUsuario = usuarioLogado?.email ?? "UNDEFINED";
      });
    }
  }

  @override
  void initState() {
    _recuperarDadosUsuario()
        .then((value) => {_montarListaContatos(_emailUsuario)});
    super.initState();
  }

  Color primaryColor = const Color(0xff25d366);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const MyAppBar(),
          backgroundColor: Colors.white ,
          body: Stack(
            children: [
              ListView.builder(
                  itemCount: _contactList.length,
                  itemBuilder: (context, index) {
                    return ContactCard(
                        nameOfPerson: _contactList[index].nameOfContact,
                        urlImage: _contactList[index].urlImageContact,
                        emailUsuario: _emailUsuario,
                        keyRelationId: _contactList[index].keyRelationId,
                        meuContato: _contactList[index].meuContato == "true"
                      // lastMessage: dataList[index]['lastMessage']!
                    );
                  }),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () async {
                    print("Botão flutuante pressionado"); // Adicione esta linha para depuração
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddContacts()),
                    );

                    // Após retornar da tela AddContacts, atualiza os dados
                    setState(() {});
                  },
                  backgroundColor: primaryColor,
                  child: Icon(Icons.person_add_alt_1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _montarListaContatos(String emailUsuarioLogado) async {
    List<Map<Object, String?>> listaMyContacts =
        await getListContacts(emailUsuarioLogado, 'contactOwner');
    listaMyContacts
        .addAll(await getListContacts(emailUsuarioLogado, 'emailContact'));

    Set<String?> uniqueKeys = Set<String?>();
    List<Contact> contact = [];

    for (var element in listaMyContacts) {
      String? keyRelationId = element['keyRelationId'];
      if (!uniqueKeys.contains(keyRelationId)) {
        uniqueKeys.add(keyRelationId);
        contact.add(Contact(
            element['nameOfPerson']!,
            element['urlImage']!,
            element['keyRelationId']!,
            (element['contactOwner']! == emailUsuarioLogado).toString()));
      }
    }

    setState(() {
      _contactList.addAll(contact);
    });
  }

  Future<List<Map<String, String?>>> getListContacts(
      String emailUsuarioLogado, String chaveBusca) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('contacts')
        .where(chaveBusca, isEqualTo: emailUsuarioLogado)
        .get();

    List<Map<String, String?>> dataList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return {
        'contactOwner': data['contactOwner'] as String?,
        'nameOfPerson': data['nameOfPerson'] as String?,
        'urlImage': data['urlImage'] as String?,
        'keyRelationId': data['keyRelationId'] as String?
      };
    }).toList();
    return dataList;
  }
}

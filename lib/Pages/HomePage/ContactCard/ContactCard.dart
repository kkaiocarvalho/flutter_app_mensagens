import 'package:flutter/material.dart';
import 'package:hackathon_unipac/Pages/ChatPage/ChatPage.dart';
import 'package:hackathon_unipac/Utils/iconUtil.dart';

class ContactCard extends StatefulWidget implements PreferredSizeWidget {
  final String nameOfPerson;
  final String keyRelationId;
  final String emailUsuario;
  final bool meuContato;

  // final String? lastMessage;
  final String urlImage;

  const ContactCard(
      {required this.nameOfPerson,
      required this.emailUsuario,
      required this.keyRelationId,
      required this.meuContato,
      // this.lastMessage,
      required this.urlImage});

  @override
  _ContactCardWidget createState() => _ContactCardWidget(
        nameOfPerson: nameOfPerson,
        emailUsuario: emailUsuario,
        keyRelationId: keyRelationId,
        meuContato: meuContato,
        // lastMessage: lastMessage,
        urlImage: urlImage,
      );

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _ContactCardWidget extends State<ContactCard> {
  final String nameOfPerson;
  final String keyRelationId;
  final String emailUsuario;
  final bool meuContato;

  // final String? lastMessage;
  final String urlImage;

  _ContactCardWidget({
    required this.nameOfPerson,
    required this.keyRelationId,
    required this.emailUsuario,
    required this.meuContato,
    // this.lastMessage,
    required this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    Color detalhesCores = Color(0xffe0e0e0);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyChatScreen(
              nameContact: nameOfPerson,
              keyRelationId: keyRelationId,
              emailUsuario: emailUsuario,
              meuContato: meuContato,
              // // lastMessage: lastMessage!,
              urlImage: urlImage,
            ),
          ),
        );
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: detalhesCores, width: 1.0)),
          ),
          child: Row(children: [
            IconAvatar(urlImage: urlImage, nameOfPerson: nameOfPerson),
            SizedBox(width: 8.0),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Text(
                  nameOfPerson,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                  // child: Text(lastMessage!),
                  ),
            ])
          ])),
    );
  }
}

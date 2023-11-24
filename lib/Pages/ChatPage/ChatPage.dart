import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_unipac/Pages/ChatPage/ChatBox.dart';
import 'package:hackathon_unipac/Utils/iconUtil.dart';
import 'package:hackathon_unipac/Utils/textUtil.dart';
import 'package:hackathon_unipac/model/Mensagem.dart';
import 'dart:async';

class MyChatScreen extends StatefulWidget {
  final String nameContact;
  final String urlImage;
  final String keyRelationId;
  final String emailUsuario;
  final bool meuContato;

  const MyChatScreen(
      {Key? key,
      required this.urlImage,
      required this.nameContact,
      required this.keyRelationId,
      required this.meuContato,
      required this.emailUsuario})
      : super(key: key);

  @override
  State createState() => MyChatScreenState(
      nameContact: nameContact,
      urlImage: urlImage,
      keyRelationId: keyRelationId,
      meuContato: meuContato,
      emailUsuario: emailUsuario);
}

class MyChatScreenState extends State<MyChatScreen> {
  Color primaryColor = const Color(0xff25d366);
  final String nameContact;
  final String urlImage;
  final String keyRelationId;
  final String emailUsuario;
  final bool meuContato;

  final List<Mensagem> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  MyChatScreenState(
      {required this.nameContact,
      required this.urlImage,
      required this.emailUsuario,
      required this.meuContato,
      required this.keyRelationId});

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmitted(String message) {
    _textController.clear();
    if (message.isNotEmpty) {
      setState(() {
        _messages.insert(0, Mensagem(emailUsuario, message));
      });
    }

    _enviarMensagemParaFirestore(emailUsuario, message, keyRelationId);

    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Container(
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: MyTextFormat(message: nameContact),
                ),
                IconAvatar(urlImage: urlImage, nameOfPerson: nameContact),
              ],
            ),
          ),
        ),
        bottom: meuContato
            ? null
            : PreferredSize(
                preferredSize:
                    Size.fromHeight(30.0), // Ajuste conforme necessário
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      "Você não tem esse contato adicionado em sua lista!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where('keyRelationId', isEqualTo: keyRelationId)
                    .orderBy('dtInclusao')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        'Nenhuma mensagem',
                      ),
                    );
                  }
                  Future.microtask(() {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });

                  return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        if (emailUsuario == doc['emailSender']) {
                          return ChatBoxSendCard(
                              isRead: false, message: doc['message']);
                        } else {
                          return ChatBoxReceiverCard(message: doc['message']);
                        }
                      });
                }),
          ),
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Padding(
              padding: const EdgeInsets.only(right: 80),
              child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: TextField(
                      maxLines: 2,
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enviar uma mensagem',
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleSubmitted(_textController.text),
        tooltip: 'Enviar',
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        mini: true,
        child: const Icon(Icons.send),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  Future<void> _enviarMensagemParaFirestore(
      String emailUsuario, String message, String keyRelationId) async {
    try {
      CollectionReference messagesCollection =
          FirebaseFirestore.instance.collection('messages');

      await messagesCollection.add({
        'emailSender': emailUsuario,
        'message': message,
        'keyRelationId': keyRelationId,
        'dtInclusao': DateTime.now()
      });
      print('Mensagem enviada para o Firestore com sucesso!');
    } catch (error) {
      print('Erro ao enviar mensagem para o Firestore: $error');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatBoxSendCard extends StatelessWidget {
  final bool isRead; // Indica se a mensagem foi lida
  final message;

  ChatBoxSendCard({required this.isRead, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChatBubble(
        clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Color(0xff25d366),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 4), // Espaço entre o texto e o ícone
            isRead
                ? Icon(Icons.done_all, color: Colors.white, size: 16)
                : Icon(Icons.done, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class ChatBoxReceiverCard extends StatelessWidget {
  final String message;

  ChatBoxReceiverCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChatBubble(
        clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
        // alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Colors.white12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 4), // Espaço entre o texto e o ícone
            //TODO colocar hr
          ],
        ),
      ),
    );
  }
}

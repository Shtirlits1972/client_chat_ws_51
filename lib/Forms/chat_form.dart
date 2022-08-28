import 'package:flutter/material.dart';

class ChatForm extends StatefulWidget {
  ChatForm({Key? key}) : super(key: key);

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'chat Form',
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
    );
  }
}

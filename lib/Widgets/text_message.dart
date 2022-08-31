// import 'package:chat/models/ChatMessage.dart';
import 'package:client_chat_ws_51/Models/message_chat.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({Key? key, required this.message, required this.IsMay})
      : super(key: key);

  final MessageChat message;
  final bool IsMay;

  @override
  Widget build(BuildContext context) {
    Container container = Container(
        margin: const EdgeInsets.only(top: kDefaultPadding, left: 50),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75, vertical: kDefaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.Text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ],
        ));

    if (!IsMay) {
      container = Container(
          margin: const EdgeInsets.only(top: kDefaultPadding, right: 50),
          decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 0.75,
              vertical: kDefaultPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.NameUser,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                message.Text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ],
          ));
    }

    return container;
  }
}

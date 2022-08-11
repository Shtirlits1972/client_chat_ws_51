import 'package:client_chat_ws_51/constants.dart';
import 'package:client_chat_ws_51/message_chat.dart';
import 'package:flutter/material.dart';

Widget MessageItem(MessageChat messageChat) {
  Column column = Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              messageChat.Text,
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      ),
    ],
  );

  if (messageChat.NameUser != NameUser) {
    column = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
            child: Text(
              messageChat.NameUser,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
            child: Text(
              messageChat.Text,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      )
    ]);
  }

  return Card(
    child: column,
  );
}

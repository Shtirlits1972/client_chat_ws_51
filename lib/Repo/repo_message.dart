import 'package:client_chat_ws_51/message_chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RepoMessages with ChangeNotifier {
  List<MessageChat> _list = [];

  List<MessageChat> get getMessage => _list;

  addMessage(MessageChat message) {
    _list.add(message);
    notifyListeners();
  }

  setMessages(List<MessageChat> newList) {
    _list = newList;
    notifyListeners();
  }
}

import 'package:client_chat_ws_51/message_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Keeper {
  List<MessageChat> listMessages = [];
  Keeper();
  Keeper.init(this.listMessages);
}

class MessageCubit extends Cubit<Keeper> {
  MessageCubit(Keeper initState) : super(initState);

  void addMessage(MessageChat message) {
    state.listMessages.add(message);

    print('Add $message  total: ${state.listMessages.length} items ');

    emit(Keeper());
  }
}


// class MessageCubit extends Cubit<ClassOverall> {
//   MessageCubit(ClassOverallinitialState) : super(ClassOverallinitialState);

//   void add(MessageChat message) {
//     state.items.add(message);

//     for (int i = 0; i < state.items.length; i++) {
//       print(state.items[i]);
//     }

//     emit(ClassOverall());
//   }
// }

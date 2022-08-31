import 'package:client_chat_ws_51/dataBase/params_crud.dart';
import 'package:client_chat_ws_51/message_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Keeper {
  List<MessageChat> listMessages = [];
  Keeper();
  Keeper.init(this.listMessages, this.login, this.password, this.IsRemember);

  AppState appState = AppState.Login;

  String login = '';
  String password = '';
  bool IsRemember = false;
}

enum AppState { Register, Login, Chat }

class MessageCubit extends Cubit<Keeper> {
  AppState get getState => state.appState;

  setAppState(AppState NewAppState) {
    state.appState = NewAppState;
  }

  MessageCubit(Keeper initState) : super(initState);

  Future<bool> getRemember() async {
    String strRemember = await ParamsCrud.getParam('Remember');

    if (!strRemember.isNotEmpty && strRemember == 'T') {
      state.IsRemember = true;
    }

    return state.IsRemember;
  }

  void setCredentials(String newLogin, String newPassword, bool newIsRemember) {
    state.login = newLogin;
    state.password = newPassword;
    state.IsRemember = newIsRemember;
  }

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

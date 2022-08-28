//import 'package:client_chat_ws_51/Repo/repo_messages.dart';
//import 'package:client_chat_ws_51/Widgets/message_item.dart';
import 'package:client_chat_ws_51/Block/app_block_observer.dart';
import 'package:client_chat_ws_51/Block/message_block.dart';
import 'package:client_chat_ws_51/Forms/login_form.dart';
import 'package:client_chat_ws_51/Repo/repo_message.dart';
import 'package:client_chat_ws_51/Widgets/message_item.dart';
import 'package:client_chat_ws_51/Widgets/text_message.dart';
import 'package:client_chat_ws_51/constants.dart';
import 'package:client_chat_ws_51/dataBase/params_crud.dart';
import 'package:client_chat_ws_51/message_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

import 'dart:convert';
//import 'dart:io';
import 'package:web_socket_channel/io.dart';
//import 'package:client_chat_ws_51/Repo/repo_messages.dart';
//import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );

  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (_) => RepoMessages(),
  //       ),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  String strIsRemember = '';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    //  List<MessageChat> listMsg = [];
    ScrollController _scrollController = new ScrollController();
    // final screen_height = MediaQuery.of(context).size.height;
    // int i = 0;
    // channel.stream.listen((message) {
    //   print(message);
    //   var msg = MessageChat.fromJson(jsonDecode(message));
    //   print('${msg.NameUser}: ${msg.Text}');
    // });

    return BlocProvider(
      create: (_) => MessageCubit(Keeper()),
      child: MaterialApp(
        title: 'Client chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Websocket Chat Client'),
            centerTitle: true,
          ),
          body: BlocBuilder<MessageCubit, Keeper>(builder: (context, state) {
            String strRemember = '';
            ParamsCrud.getParam('Remember').then((String value) {
              print('Remember from block = $value');
            });

            return Center(
              child: loginForm(),
              /* 
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          MessageChat msg = MessageChat.fromJson(
                              jsonDecode(snapshot.data.toString()));

                          if (msg.type != TypeOfMessage.Text) {
                            //   listMsg.add(msg);
                            state.listMessages.add(msg);

                            int y = 0;

                            _scrollController.animateTo(
                              state.listMessages.length * 100,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 100),
                            );
                          } else if (msg.type != TypeOfMessage.Error) {
                            print('Error ${msg.Text}');
                          } else if (msg.type != TypeOfMessage.Success) {
                            print('Success ${msg.Text}');
                          } else if (msg.type != TypeOfMessage.ServerInfo) {
                            print('Info ${msg.Text}');
                          }
                        }

                        print(snapshot.data);
                        int a = 0;
                        return ListView.builder(
                          itemCount: state.listMessages.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return TextMessage(
                              message: state.listMessages[index],
                            );
                            // return MessageItem(state.listMessages[index]);
                          },
                        );
                        //  Text(snapshot.hasData ? '${snapshot.data}' : '')
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Form(
                          child: TextFormField(
                            controller: controller,
                            onEditingComplete: () {
                              try {
                                String text = controller.text;
                                MessageChat messageChat = MessageChat(
                                    NameUser, text, TypeOfMessage.Text);
                                String encodedMessage = jsonEncode(messageChat);
                                channel.sink.add(encodedMessage);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              } catch (e) {
                                print(e);
                              }

                              print(controller.text);
                              controller.clear();
                            },
                            decoration: const InputDecoration(
                                labelText: 'Send a message'),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              try {
                                String text = controller.text;
                                MessageChat messageChat = MessageChat(
                                    NameUser, text, TypeOfMessage.Text);
                                String encodedMessage = jsonEncode(messageChat);
                                channel.sink.add(encodedMessage);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                print(text);
                              } catch (e) {
                                print(e);
                              }

                              print(controller.text);
                              controller.clear();
                            },
                            icon: const Icon(Icons.telegram_sharp),
                          )),
                    ],
                  ),
                ],
              ),
           */
            );
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    ParamsCrud.init();
    super.initState();

    // setState(() async {
    //   strIsRemember = await ParamsCrud.getParam('Remember');

    // });

    print(strIsRemember);
  }
}

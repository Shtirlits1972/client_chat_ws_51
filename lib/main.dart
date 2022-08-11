//import 'package:client_chat_ws_51/Repo/repo_messages.dart';
//import 'package:client_chat_ws_51/Widgets/message_item.dart';
import 'package:client_chat_ws_51/Repo/repo_message.dart';
import 'package:client_chat_ws_51/Widgets/message_item.dart';
import 'package:client_chat_ws_51/constants.dart';
import 'package:client_chat_ws_51/message_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

import 'dart:convert';
//import 'dart:io';
import 'package:web_socket_channel/io.dart';
//import 'package:client_chat_ws_51/Repo/repo_messages.dart';
//import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepoMessages(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final channel = IOWebSocketChannel.connect(url);
    List<MessageChat> listMsg = [];

    // channel.stream.listen((message) {
    //   print(message);
    //   var msg = MessageChat.fromJson(jsonDecode(message));
    //   print('${msg.NameUser}: ${msg.Text}');
    // });

    return MaterialApp(
      title: 'Client chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Websocket Chat Client'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                child: Center(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    MessageChat msg = MessageChat.fromJson(
                        jsonDecode(snapshot.data.toString()));
                    if (msg.NameUser != 'Server') {
                      listMsg.add(msg);
                    }
                  }

                  print(snapshot.data);
                  int a = 0;
                  return ListView.builder(
                    itemCount: listMsg.length,
                    itemBuilder: (context, index) {
                      return MessageItem(listMsg[index]);
                    },
                  );
                  //  Text(snapshot.hasData ? '${snapshot.data}' : '')
                },
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Form(
                    child: TextFormField(
                      controller: controller,
                      decoration:
                          const InputDecoration(labelText: 'Send a message'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            try {
              String text = controller.text;
              MessageChat messageChat = MessageChat(NameUser, text);
              String encodedMessage = jsonEncode(messageChat);
              channel.sink.add(encodedMessage);
            } catch (e) {
              print(e);
            }

            print(controller.text);
            controller.clear();
          },
          tooltip: 'Send message',
          child: const Icon(Icons.telegram),
        ),
      ),
    );
  }
}

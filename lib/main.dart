import 'package:client_chat_ws_51/Block/app_block_observer.dart';
import 'package:client_chat_ws_51/Block/message_block.dart';
import 'package:client_chat_ws_51/Forms/chat_form.dart';
import 'package:client_chat_ws_51/Forms/login_form.dart';
import 'package:client_chat_ws_51/Repo/repo_message.dart';
import 'package:client_chat_ws_51/Widgets/message_item.dart';
import 'package:client_chat_ws_51/Widgets/text_message.dart';
import 'package:client_chat_ws_51/constants.dart';
import 'package:client_chat_ws_51/dataBase/params_crud.dart';
import 'package:client_chat_ws_51/message_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
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
    TextEditingController loginController = TextEditingController();
    TextEditingController passController = TextEditingController();
    bool IsRemember = true;

    ScrollController _scrollController = new ScrollController();
    // final screen_height = MediaQuery.of(context).size.height;
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

            return StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    print(snapshot.data);

                    MessageChat msg = MessageChat.fromJson(
                        jsonDecode(snapshot.data.toString()));

                    if (msg != null) {
                      if (msg.type == TypeOfMessage.Success) {
                        state.appState = AppState.Chat;
                      } else if (msg.type == TypeOfMessage.Error) {
                        print('Error: ${msg.Text}');
                        ShowSnackBar(msg.Text);
                      } else if (msg.type == TypeOfMessage.Text) {
                        state.listMessages.add(msg);

                        _scrollController.animateTo(
                          state.listMessages.length * 100,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 100),
                        );
                      } else if (msg.type != TypeOfMessage.ServerInfo) {
                        print('Info ${msg.Text}');
                      }
                    }
                  }

                  if (state.appState == AppState.Login) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: loginController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  hintText:
                                      'Enter valid mail id as abc@gmail.com'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Enter your secure password'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextButton(
                              onPressed: () async {
                                print(loginController.text +
                                    ' ' +
                                    passController.text);

                                String loginValue = loginController.text;
                                String passwordValue = passController.text;
                                String rememberValue = 'T';

                                if (!IsRemember) {
                                  rememberValue = 'F';
                                }

                                await ParamsCrud.updParam(
                                    'NameUser', loginValue);
                                await ParamsCrud.updParam(
                                    'Password', passwordValue);
                                await ParamsCrud.updParam(
                                    'Remember', rememberValue);

                                MessageChat messageChat = MessageChat(
                                    loginValue,
                                    loginValue + '\$' + passwordValue,
                                    TypeOfMessage.LogIn);

                                String encodedMessage = jsonEncode(messageChat);
                                channel.sink.add(encodedMessage);
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              String loginValue =
                                  await ParamsCrud.getParam('NameUser');
                              print('loginValue = $loginValue');

                              String passwordValue =
                                  await ParamsCrud.getParam('Password');
                              print('passwordValue = $passwordValue');

                              String rememberValue =
                                  await ParamsCrud.getParam('Remember');
                              print('rememberValue = $rememberValue');

                              setState(() {
                                state.appState = AppState.Register;
                              });
                            },
                            child: Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: IsRemember,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      IsRemember = value!;
                                    });
                                    print(IsRemember);
                                  }),
                              Container(
                                child: Text(
                                  'Remember me',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  } else if (state.appState == AppState.Chat) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.listMessages.length,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              return TextMessage(
                                message: state.listMessages[index],
                              );
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
                                      String encodedMessage =
                                          jsonEncode(messageChat);
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
                                      String encodedMessage =
                                          jsonEncode(messageChat);
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
                    );
                  } else if (state.appState == AppState.Register) {
                    print('not implemented  :-(');
                    return Center(
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    );
                  }
                  return Text(
                    'Error',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  );
                });
          }),
        ),
      ),
    );
  }

  ShowSnackBar(String textMsg) {
    final snackBar = SnackBar(
      content: Text(textMsg),
      duration: Duration(
        seconds: 5,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

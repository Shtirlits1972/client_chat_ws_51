import 'package:client_chat_ws_51/Block/app_block_observer.dart';
import 'package:client_chat_ws_51/Block/message_block.dart';
import 'package:client_chat_ws_51/Models/users.dart';
import 'package:client_chat_ws_51/Widgets/message_item.dart';
import 'package:client_chat_ws_51/Widgets/text_message.dart';
import 'package:client_chat_ws_51/constants.dart';
import 'package:client_chat_ws_51/dataBase/params_crud.dart';
import 'package:client_chat_ws_51/Models/message_chat.dart';
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

    TextEditingController registerEmailLoginController =
        TextEditingController();
    TextEditingController registerPassController = TextEditingController();
    TextEditingController registerUserFioController = TextEditingController();

    bool IsRemember = true;
    bool regIsRemember = true;

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
              if (value == 'T') {
                ParamsCrud.getParam('NameUser').then((String value) {
                  loginController.text = value;
                });
                ParamsCrud.getParam('Password').then((String value) {
                  passController.text = value;
                });
              }
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
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: loginController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
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

                                state.login = loginValue;

                                DateTime time = DateTime.now();

                                MessageChat messageChat = MessageChat(
                                    loginValue,
                                    loginValue,
                                    loginValue + '\$' + passwordValue,
                                    time,
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
                            onPressed: () {
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
                              bool IsMay = false;

                              if (state.listMessages[index].LoginEmail ==
                                  state.login) {
                                IsMay = true;
                              }
                              int y = 0;
                              return TextMessage(
                                  message: state.listMessages[index],
                                  IsMay: IsMay);
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
                                      DateTime time = DateTime.now();
                                      MessageChat messageChat = MessageChat(
                                          state.NameUser,
                                          NameUser,
                                          text,
                                          time,
                                          TypeOfMessage.Text);
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
                                      DateTime time = DateTime.now();
                                      MessageChat messageChat = MessageChat(
                                          NameUser,
                                          NameUser,
                                          text,
                                          time,
                                          TypeOfMessage.Text);
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
                    print('Register form');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: registerEmailLoginController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  hintText:
                                      'Enter valid mail id as abc@gmail.com'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: registerUserFioController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User name',
                                  hintText: 'Enter user name: Djon Smith'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: registerPassController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Enter your secure password'),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              child: Text(
                                'SEND REGISTER',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                              onPressed: () async {
                                print('send register');

                                String ErrorMsg = 'ERROR!';
                                bool IsError = false;

                                String RegLoginEmail =
                                    registerEmailLoginController.text;
                                String RegUserFio =
                                    registerUserFioController.text;
                                String RegPassword =
                                    registerPassController.text;

                                bool boolEmailValid =
                                    isEmail(RegLoginEmail.trim());

                                if (!boolEmailValid) {
                                  IsError = true;
                                  ErrorMsg += '\r\n Email is not valid!';
                                }

                                if (RegUserFio.trim().isEmpty) {
                                  IsError = true;
                                  ErrorMsg += '\r\n User name is empty!';
                                }

                                if (RegPassword.length < 8) {
                                  IsError = true;
                                  ErrorMsg +=
                                      '\r\n password must be at least 8 characters long !';
                                }

                                if (IsError) {
                                  final snackBar = SnackBar(
                                    content: Text(ErrorMsg),
                                    duration: Duration(
                                      seconds: 5,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  String regRememberStr = 'T';

                                  if (!IsRemember) {
                                    regRememberStr = 'F';
                                  }

                                  await ParamsCrud.updParam(
                                      'NameUser', RegLoginEmail);
                                  await ParamsCrud.updParam(
                                      'Password', RegPassword);
                                  await ParamsCrud.updParam(
                                      'Remember', regRememberStr);

                                  try {
                                    Users newUser = Users(0, RegLoginEmail,
                                        RegPassword, 'Юзер', RegUserFio);

                                    String userJson = jsonEncode(newUser);
                                    DateTime timeReg = DateTime.now();

                                    MessageChat regMessage = MessageChat(
                                        RegLoginEmail,
                                        RegUserFio,
                                        userJson,
                                        timeReg,
                                        TypeOfMessage.Register);
                                    String msgJson = jsonEncode(regMessage);

                                    setState(() {
                                      state.login = RegLoginEmail;
                                    });

                                    channel.sink.add(msgJson);

                                    print('send registration');
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: regIsRemember,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      regIsRemember = value!;
                                    });
                                    print(regIsRemember);
                                  }),
                              Container(
                                child: Text(
                                  'Remember me',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25),
                                ),
                              )
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  state.appState = AppState.Login;
                                });
                              },
                              child: const Text(
                                'BACK TO LOGIN',
                                style:
                                    TextStyle(fontSize: 30, color: Colors.blue),
                              ))
                        ],
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

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
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

import 'package:client_chat_ws_51/Models/message_chat.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

// String url = 'wss://serverchatwebsocket.somee.com/ws';
const String dbName = 'chatDB.db';
//  "wss://localhost:44375/ws"; //
//
String url = 'ws://serverchat-001-site1.htempurl.com/ws';
final channel = IOWebSocketChannel.connect(url);
//
String NameUser = 'Veider';
String Password = '123';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 10.0;

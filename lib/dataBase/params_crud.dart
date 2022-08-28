import 'dart:async';
import 'package:client_chat_ws_51/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ParamsCrud {
  static Future<String> getParam(String NameParam) async {
    String ValueParam = 'Error';

    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);

      Database db = await openDatabase(path, version: 1);

      List<Map> list = await db.rawQuery(
          'SELECT ValueParam FROM paramsTab WHERE NameParam = ? ;',
          [NameParam]);

      if (list.isNotEmpty) {
        return list[0]['ValueParam'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  static Future<void> updParam(String NameParam, String ValueParam) async {
    String command = 'UPDATE paramsTab SET ValueParam = ? WHERE NameParam = ?';

    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      int count = await db.rawUpdate(command, [ValueParam, NameParam]);

      print('row updated = $count ');
    } catch (e) {
      print(e);
    }
  }

  static Future delParam(String NameParam) async {
    String command = 'DELETE FROM paramsTab WHERE NameParam = ?';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      int count = await db.rawDelete(command, [NameParam]);

      print('row delete = $count ');
    } catch (e) {
      print(e);
    }
  }

  static Future addParam(String NameParam, String ValueParam) async {
    String command =
        'INSERT INTO paramsTab (NameParam, ValueParam) values(?,?);';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      db.transaction((txn) async {
        int id = await txn.rawInsert(command, [NameParam, ValueParam]);
        print(id);
      });
    } catch (e) {
      print(e);
    }
  }

  static init() async {
    String createParamTab = 'CREATE TABLE paramsTab (' +
        ' id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        ' NameParam VARCHAR(250) UNIQUE, ' +
        ' ValueParam VARCHAR(250)  ); ';

    String UserParamAdd =
        'INSERT INTO paramsTab (NameParam, ValueParam) values(\'NameUser\',\'\');';

    String PasswordParamAdd =
        'INSERT INTO paramsTab (NameParam, ValueParam) values(\'Password\',\'\');';

    String RememberParamAdd =
        'INSERT INTO paramsTab (NameParam, ValueParam) values(\'Remember\',\'F\');';

    //      await getDatabasesPath().then((String strPath){
    // String path = join(strPath, dbName);

    //       final database = openDatabase(path, onCreate: (db, version) async {
    //         db.
    //         print('table paramsTab Created');
    //         await db.execute(UserParamAdd);
    //         await db.execute(PasswordParamAdd);
    //         await db.execute(RememberParamAdd);
    //         // print('theme added!');
    //       }, version: 1);

    //       });

    await getDatabasesPath().then((String strPath) {
      String path = join(strPath, dbName);
      try {
        final database = openDatabase(path, onCreate: (db, version) async {
          db.execute(createParamTab);
          print('table paramsTab Created');
          await db.execute(UserParamAdd);
          await db.execute(PasswordParamAdd);
          await db.execute(RememberParamAdd);
          // print('theme added!');
        }, version: 1);
      } catch (e) {
        print(e);
      }
    });
  }
}

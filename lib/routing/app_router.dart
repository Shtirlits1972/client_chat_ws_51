import 'package:client_chat_ws_51/Forms/login_form.dart';
import 'package:flutter/material.dart';

class Approuter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => loginForm(),
        );

      // case '/ChatForm':
      //   return MaterialPageRoute(
      //     builder: (context) => ChatForm(),
      //   );

      default:
        return null;
    }
  }

  void dispose() {}
}

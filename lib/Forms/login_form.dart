import 'package:client_chat_ws_51/constants.dart';
import 'package:client_chat_ws_51/dataBase/params_crud.dart';
import 'package:flutter/material.dart';

class loginForm extends StatefulWidget {
  const loginForm() : super();

  @override
  _loginFormState createState() => _loginFormState();
}

class _loginFormState extends State<loginForm> {
  bool IsRemember = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController passController = TextEditingController();
    //  AuthModule auth = new AuthModule();

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
                  hintText: 'Enter valid mail id as abc@gmail.com'),
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
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () async {
                print(loginController.text + ' ' + passController.text);

                String loginValue = loginController.text;
                String passwordValue = passController.text;
                String rememberValue = 'T';

                if (!IsRemember) {
                  loginValue = '';
                  passwordValue = '';
                  rememberValue = 'F';
                }

                await ParamsCrud.updParam('NameUser', loginValue);
                await ParamsCrud.updParam('Password', passwordValue);
                await ParamsCrud.updParam('Remember', rememberValue);

                // user _user =
                //     await auth.login(loginController.text, passController.text);

                // if (_user != null) {
                //   context.read<user_repo>().setCurrentUsers(_user);
                //   Navigator.of(context).pushNamed(
                //     '/GoodsList',
                //   );
                // } else {
                //   final snackBar = SnackBar(
                //     content: Text('incorrect email and(or) password !'),
                //     duration: Duration(
                //       seconds: 3,
                //     ),
                //   );
                //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // }
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              String loginValue = await ParamsCrud.getParam('NameUser');
              print('loginValue = $loginValue');

              String passwordValue = await ParamsCrud.getParam('Password');
              print('passwordValue = $passwordValue');

              String rememberValue = await ParamsCrud.getParam('Remember');
              print('rememberValue = $rememberValue');

              // final snackBar = SnackBar(
              //   content: Text('Registration not implemented!'),
              //   duration: Duration(
              //     seconds: 3,
              //   ),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text(
              'Register',
              style: TextStyle(color: Colors.blue, fontSize: 20),
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
                  style: TextStyle(color: Colors.blue, fontSize: 25),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

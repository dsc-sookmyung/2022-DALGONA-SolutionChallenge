import 'package:flutter/material.dart';

import '../tabbar_mainview.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  late String _email;
  late String _password;

  void validateAndSave() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => tabBarMainPage()),);

    // final form = formKey.currentState;
    // if (form!.validate()) {
    //
    //   Navigator.pop(context);
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => tabBarMainPage()),);
    //
    // } else {
    //   print('Form is invalid Email: $_email, password: $_password');
    // }
  }

  void forgotPassword(){
    print('forgot password is clicked! ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: const EdgeInsets.all(30),

        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 0.0, top:0.0, right: 0.0, bottom: 20.0),
                alignment: Alignment.center,
                child: const Text(
                    "로그인",
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xff5AA9DD) ),
                ),

              ),
              //로그인
              Container(
                margin: const EdgeInsets.only(left: 0.0, top:40.0, right: 0.0, bottom: 10.0),
                child: RaisedButton(
                  color: const Color(0xff97D5FE),
                  child: const Text(
                    '구글 로그인',
                    style: TextStyle(fontSize: 20.0, color: Color(0xffFFFFFF), ),
                  ),
                  onPressed: validateAndSave,
                ),
                height: 40,
              ),



            ],
          ),
        ),
      ),
    );
  }
}
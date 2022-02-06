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
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $_email, password: $_password');

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => tabBarMainPage()),);

    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
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

              Container(
                child: Column(
                  children: <Widget> [

                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                      value!.isEmpty ? 'Email can\'t be empty' : null,
                      onSaved: (value) => _email = value!,
                    ),

                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) =>
                      value!.isEmpty ? 'Password can\'t be empty' : null,
                      onSaved: (value) => _password = value!,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: forgotPassword,
                          child: const Text(
                            "비밀번호 찾기",
                            style: TextStyle(fontSize: 12.0, color: Color(0xff525457), ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),


              //로그인
              Container(
                margin: const EdgeInsets.only(left: 0.0, top:40.0, right: 0.0, bottom: 10.0),
                child: RaisedButton(
                  color: const Color(0xff97D5FE),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 20.0, color: Color(0xffFFFFFF), ),
                  ),
                  onPressed: validateAndSave,
                ),
                height: 40,
              ),

              //회원가입
              Container(
                margin: const EdgeInsets.only(left: 0.0, top:10.0, right: 0.0, bottom: 0.0),
                child: RaisedButton(
                  color: const Color(0xff97D5FE),
                  child: const Text(
                    '회원가입',
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
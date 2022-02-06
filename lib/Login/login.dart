import 'package:flutter/material.dart';

import '../Speaking/selectmode_mainview.dart';

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
      Navigator.push(context, MaterialPageRoute(builder: (context) => selectModeMainPage()),);

    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  void forgotPassword(){
    print('forgot password is clicked! ');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new Container(
        padding: EdgeInsets.all(30),

        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 0.0, top:0.0, right: 0.0, bottom: 20.0),
                alignment: Alignment.center,
                child: new Text(
                    "로그인",
                    style: new TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xff5AA9DD) ),
                ),

              ),

              Container(
                child: new Column(
                  children: <Widget> [

                    new TextFormField(
                      decoration: new InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                      value!.isEmpty ? 'Email can\'t be empty' : null,
                      onSaved: (value) => _email = value!,
                    ),

                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(labelText: 'Password'),
                      validator: (value) =>
                      value!.isEmpty ? 'Password can\'t be empty' : null,
                      onSaved: (value) => _password = value!,
                    ),

                    new TextButton(
                        onPressed: forgotPassword,
                        child: Text(
                          "비밀번호 찾기",
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 12.0, color: Color(0xff525457), ),
                        ),
                    )

                  ],
                ),
              ),


              //로그인
              Container(
                margin: EdgeInsets.only(left: 0.0, top:40.0, right: 0.0, bottom: 10.0),
                child: new RaisedButton(
                  color: Color(0xff97D5FE),
                  child: new Text(
                    '로그인',
                    style: new TextStyle(fontSize: 20.0, color: Color(0xffFFFFFF), ),
                  ),
                  onPressed: validateAndSave,
                ),
                height: 40,
              ),

              //회원가입
              Container(
                margin: EdgeInsets.only(left: 0.0, top:10.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                  color: Color(0xff97D5FE),
                  child: new Text(
                    '회원가입',
                    style: new TextStyle(fontSize: 20.0, color: Color(0xffFFFFFF), ),
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
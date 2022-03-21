import 'package:flutter/material.dart';

import '../tabbar_mainview.dart';
import 'findpassword.dart';
import 'signup.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = new GlobalKey<FormState>();

  late String _email;
  late String _password;

  void validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $_email, password: $_password');

      signIn(_email, _password);

    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  void forgotPassword(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => findPasswordPage()),);
  }

  void signUp(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()),);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new Container(
        padding: EdgeInsets.all(30),

        child: new Form(
          key: _formKey,
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

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: forgotPassword,
              child: const Text(
                "비밀번호 찾기",
                style: TextStyle(fontSize: 12.0, color: Color(0xff666666), ),
              ),
            )
          ]
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
                    style: new TextStyle(fontSize: 16.0, color: Color(0xffFFFFFF), ),
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
                    style: new TextStyle(fontSize: 16.0, color: Color(0xffFFFFFF), ),
                  ),
                  onPressed: signUp,
                ),
                height: 40,
              ),

            ],
          ),
        ),
      ),
    );
  }

  void signIn(String email, pass) async {

    var url = Uri.http('10.0.2.2:8080', '/user/login');

    final data = jsonEncode({'email': email, 'password': pass});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);

      String data = body["result"];

      ///!! 일단 result 값으로 지정해 놓음. 후에 서버와 논의하여 data값 설정하기.
      print("data: " + data.toString());

      if(data != "fail"){
        print("로그인에 성공하셨습니다.");
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => tabBarMainPage()),);
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }
}
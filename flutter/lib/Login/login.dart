import 'package:flutter/material.dart';

import '../tabbar_mainview.dart';
import 'findpassword.dart';
import 'signup.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/server.dart';

var authToken = '';
var refreshToken = '';
var name = "";
var email = "";

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

  void forgotPassword() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => findPasswordPage()),
    );
  }

  void signUp() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final authToken = Provider.of<AccessToken>(context);

    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: new Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xffF3F4F6),
                    Color(0xffEFF4FA),
                    Color(0xffECF4FE),
                  ],
                  stops: [0.3, 0.7, 0.9, ],
                ),
              ),
          // color: Color(0xfff0f8ff),
          child: Container(
            padding: EdgeInsets.all(30),
            child: new Form(
              key: _formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 0.0, top: 0.0, right: 0.0, bottom: 20.0),
                    alignment: Alignment.center,
                    child: new Text(
                      "로그인",
                      style: new TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4478FF)),
                    ),
                  ),

                  Container(
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                              value!.isEmpty ? 'Email can\'t be empty' : null,
                          onSaved: (value) => _email = value!,
                        ),
                        new TextFormField(
                          obscureText: true,
                          decoration:
                              new InputDecoration(labelText: 'Password'),
                          validator: (value) => value!.isEmpty
                              ? 'Password can\'t be empty'
                              : null,
                          onSaved: (value) => _password = value!,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: forgotPassword,
                                child: const Text(
                                  "비밀번호 찾기",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(0xff666666),
                                  ),
                                ),
                              )
                            ])
                      ],
                    ),
                  ),

                  //로그인
                  Container(
                    margin: EdgeInsets.only(left: 0.0, top: 40.0, right: 0.0, bottom: 10.0),

                    child: new RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: Color(0xff4478FF),
                      child: new Text(
                        '로그인',
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                      onPressed: validateAndSave,
                    ),
                    height: 45,
                  ),

                  //회원가입
                  Container(
                    margin: EdgeInsets.only(
                        left: 0.0, top: 10.0, right: 0.0, bottom: 0.0),
                    child: new RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: Color(0xff4478FF),
                      child: new Text(
                        '회원가입',
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                      onPressed: signUp,
                    ),
                    height: 45,
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  void signIn(String email, pass) async {
    var url = Uri.http('${serverHttp}:8080', '/user/login');

    final data = jsonEncode({'email': email, 'password': pass});

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json"
    });

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);

      dynamic data = body["data"];



      ///!! 일단 result 값으로 지정해 놓음. 후에 서버와 논의하여 data값 설정하기.
      //print("token: " + token.toString());

      if (body["result"] == "success") {
        String token = data["accessToken"];
        refreshToken = data["refreshToken"];
        print("로그인에 성공하셨습니다.");
        authToken = token;

        userInfo();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => tabBarMainPage()),
        );
      }
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '로그인 실패',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('로그인에 실패하였습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  void userInfo() async {
    var url = Uri.http('${serverHttp}:8080', '/user/info');

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);
    print("Bearer ${authToken}");
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      var data = body["data"];
      email = data["email"].toString();
      name = data["name"].toString();
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }
}

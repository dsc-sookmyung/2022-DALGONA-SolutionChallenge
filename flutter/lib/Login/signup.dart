import 'dart:ffi';

import 'package:flutter/material.dart';
import 'login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/server.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class emailCheck {
  late final Bool data;

  emailCheck({required this.data});

  factory emailCheck.fromJson(Map<dynamic, dynamic> json) {
    return emailCheck(
      data: json['data'] as Bool,
    );
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  bool _isChecked = false;

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  final TextEditingController _authCode = new TextEditingController();

  late String _emailAuthCode;

  void validateAndSignUp() {
    if (_formKey.currentState!.validate()) {
      signUp(_email.text, _name.text, _pass.text);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> emailAuth(String email) async {
    var url = Uri.http('${serverHttp}:8080', 'email/code/send');
    final data = jsonEncode({'email': email});

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json"
    });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);

      if(body["result"] != "fail"){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '인증코드 전송 성공',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('이메일로 인증코드를 전송하였습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.push(context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  // );
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '인증코드 전송 실패',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('이메일 인증코드 전송에 실패하였습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.push(context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  // );
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }

    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  existEmail(String email) async {
    Uri.encodeComponent(email);

    Map<String, String> _queryParameters = <String, String>{
      'email': email,
    };
    Uri.encodeComponent(email);
    var url = Uri.http('${serverHttp}:8080', '/user/email', _queryParameters);

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json"
    });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);

      bool data = body["data"];

      print("data: " + data.toString());

      if (!data) {
        print("중복 체크에 성공하셨습니다.");

        emailAuth(email);
      }
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '이미 등록된 이메일',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('해당 이메일은 이미 가입되어 있는 이메일입니다. 다른 이메일을 이용해 주세요.'),
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
      print('error : ${response.reasonPhrase}');
    }
  }

  void signUp(String email, name, pass) async {
    var url = Uri.http('${serverHttp}:8080', '/user');

    final data = jsonEncode({'email': email, 'name': name, 'password': pass});

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

      if(body["result"] == "success"){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '회원가입 성공',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('회원가입에 성공하였습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.push(context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  // );
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '회원가입 실패',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('회원가입에 실패하였습니다.'),
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
      print('error : ${response.reasonPhrase}');
    }
  }

  checkAuthCode(String email, authCode) async {
    var url = Uri.http('${serverHttp}:8080', '/email/code/verify');

    final data = jsonEncode({'email': email, 'authCode': authCode});

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

      if(body["result"] != "fail"){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '이메일 인증 성공',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('이메일 인증에 성공하였습니다.'),
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
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '인증 실패',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('이메일 인증에 실패하였습니다.'),
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
      print('error : ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            //resizeToAvoidBottomInset : false,
            body: SingleChildScrollView(
                child: new Container(
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
          child: Container(
              margin: EdgeInsets.only(
                  top: 120.0, left: 30.0, right: 30.0, bottom: 80.0),
              child: new Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 40.0),
                      child: Center(
                        child: Text(
                          '회원가입',
                          style: new TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff4478FF)),
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        '이메일',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0, right: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff666666), width: 2.0),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 0, 0, 0),
                                hintText: '이메일을 입력하세요.',
                                hintStyle: TextStyle(fontSize: 16.0)),
                            validator: (value) =>
                                value!.isEmpty ? '이메일을 입력해 주세요.' : null,
                            controller: _email,
                          ),
                          height: 40,
                          width: 240,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: RaisedButton(
                            color: Color(0xff4478FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '인 증',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffFFFFFF)),
                            ),
                            onPressed: () {
                              existEmail(_email.text);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          width: 70,
                        )
                      ],
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        '이메일 인증 번호',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0, right: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff666666), width: 2.0),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 0, 0, 0),
                                hintText: '인증번호를 입력하세요.',
                                hintStyle: TextStyle(fontSize: 16.0)),
                            validator: (value) =>
                                value!.isEmpty ? '인증 코드를 입력해 주세요' : null,
                            controller: _authCode,
                          ),
                          height: 40,
                          width: 240,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: RaisedButton(
                            color: Color(0xff4478FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '확 인',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffFFFFFF)),
                            ),
                            onPressed: () {
                              checkAuthCode(_email.text, _authCode.text);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          width: 70,
                        )
                      ],
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '이름',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff666666), width: 2.0),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            hintText: '이름을 입력하세요.',
                            hintStyle: TextStyle(fontSize: 16.0)),
                        validator: (value) =>
                            value!.isEmpty ? '이름을 입력해 주세요.' : null,
                        controller: _name,
                      ),
                      height: 40,
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '비밀번호',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff666666), width: 2.0),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            hintText: '비밀번호를 입력하세요.',
                            hintStyle: TextStyle(fontSize: 16.0)),
                        validator: (value) =>
                            value!.isEmpty ? '비밀번호를 입력해 주세요.' : null,
                        controller: _pass,
                      ),
                      height: 40,
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '비밀번호 확인',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "비밀번호가 확인되지 않았습니다.";
                          } else if (value != _pass.text) {
                            return "비밀번호가 일치하지 않습니다.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff666666), width: 2.0),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            hintText: '비밀번호를 입력하세요.',
                            hintStyle: TextStyle(fontSize: 16.0)),
                      ),
                      height: 40,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color(0xff4478FF),
                        child: new Text(
                          '회원가입',
                          style: new TextStyle(
                            fontSize: 18.0,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        onPressed: () {
                          validateAndSignUp();
                        },
                      ),
                      height: 45,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('이미 계정이 있으신가요?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                                '로그인',
                              style: TextStyle(
                                color: Color(0xff4478FF),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ))));
  }
}

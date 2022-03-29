import 'dart:ffi';

import 'package:flutter/material.dart';
import 'login.dart';
import 'changepassword.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/server.dart';

class findPasswordPage extends StatefulWidget {
  const findPasswordPage({Key? key}) : super(key: key);

  @override
  State<findPasswordPage> createState() => _findPasswordPageState();
}

class _findPasswordPageState extends State<findPasswordPage> {

  final _formKey = new GlobalKey<FormState>();

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _emailAuthCode = new TextEditingController();

  Future<void> emailAuth(String email) async {

<<<<<<< HEAD
    var url = Uri.http('104.197.249.40:8080', 'email/code/pwd/send');
=======
    var url = Uri.http('${serverHttp}:8080', 'email/code/pwd/send');
>>>>>>> 031cfe11ec397201bc496a9659ef2925109b6fd7
    final data = jsonEncode({'email': email});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json"});

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  checkAuthCode(String email, authCode) async {

<<<<<<< HEAD
    var url = Uri.http('104.197.249.40:8080', '/email/code/pwd/verify');
=======
    var url = Uri.http('${serverHttp}:8080', '/email/code/pwd/verify');
>>>>>>> 031cfe11ec397201bc496a9659ef2925109b6fd7

    final data = jsonEncode({'email': email, 'authCode': authCode});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);

      String data = body["result"];

      print("result: " + data.toString());

      if(data == "success"){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => changePasswordPage(email: _email.text)));

      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  sendPassword(String email) async {
<<<<<<< HEAD
    var url = Uri.http('104.197.249.40:8080', '/email/pwd');
=======
    var url = Uri.http('${serverHttp}:8080', '/email/pwd');
>>>>>>> 031cfe11ec397201bc496a9659ef2925109b6fd7

    final data = jsonEncode({'email': email});

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  changePassword(String email, pass) async {

<<<<<<< HEAD
    var url = Uri.http('104.197.249.40:8080', '/user/password/lost');
=======
    var url = Uri.http('${serverHttp}:8080', '/user/password/lost');
>>>>>>> 031cfe11ec397201bc496a9659ef2925109b6fd7

    final data = jsonEncode({'email': email, 'password': pass});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
    }
    else {
    print('error : ${response.reasonPhrase}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(30),
        key: _formKey,
        child: new Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(top:120.0, bottom: 70.0),
                  child: Center(
                    child: Text(
                      '비밀번호 찾기',
                      style: new TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xff5AA9DD) ),
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '이메일',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only( right: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                            ),
                            hintText: '이메일을 입력하세요.'
                        ),
                        validator: (value) => value!.isEmpty ? '이메일을 입력해 주세요.' : null,
                        controller: _email,
                      ),
                      height: 40,
                      width: 240,
                    ),
                    Container(
                      child: RaisedButton(
                        color: Color(0xff97D5FE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '인 증',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
                        ),
                        onPressed: (){
                          emailAuth(_email.text);
                        },
                      ),
                      width: 70,
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    '인증번호',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                        ),
                        hintText: '인증번호를 입력하세요.'
                    ),
                    validator: (value) => value!.isEmpty ? '인증번호를 입력해 주세요.' : null,
                    controller: _emailAuthCode,
                  ),
                  height: 40,
                  width: 240,
                ),
                Container(
                  margin: EdgeInsets.only(top:70.0, bottom: 10.0),
                  child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '인증번호 확인',
                      style: new TextStyle(fontSize: 18.0, color: Color(0xffFFFFFF), ),
                    ),
                    onPressed: (){
                      checkAuthCode(_email.text, _emailAuthCode.text);
                    },
                  ),
                  height: 40,
                ),
                Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('비밀번호가 기억나셨나요?'),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                        },
                        child: Text('로그인'),
                      )
                    ],
                  ),
                )

              ],
            )
        ),
      ),
    );
  }
}

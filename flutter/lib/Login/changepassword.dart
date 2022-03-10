import 'dart:ffi';

import 'package:flutter/material.dart';
import 'login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class changePasswordPage extends StatefulWidget {
  const changePasswordPage({Key? key}) : super(key: key);

  @override
  State<changePasswordPage> createState() => _changePasswordPageState();
}

class _changePasswordPageState extends State<changePasswordPage> {

  final _formKey = new GlobalKey<FormState>();

  final TextEditingController _pass = new TextEditingController();
  final TextEditingController _checkPass = new TextEditingController();


  sendPassword(String email) async {
    var url = Uri.http('localhost:8080', '/email/pwd');

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

    var url = Uri.http('localhost:8080', '/user/password/lost');

    final data = jsonEncode({'email': email, 'password': pass});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);

      bool data = body["data"];

      print("data: " + data.toString());
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
                  margin: EdgeInsets.only(top:80.0, bottom: 50.0),
                  child: Center(
                    child: Text(
                      '비밀번호 변경',
                      style: new TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xff5AA9DD) ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    '변경할 비밀번호',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                        ),
                        hintText: '변경할 비밀번호를 입력하세요.'
                    ),
                    validator: (value) => value!.isEmpty ? '변경할 비밀번호를 입력해 주세요.' : null,
                    controller: _pass,
                  ),
                  height: 40,
                  width: 240,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    '비밀번호 확인',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                        ),
                        hintText: '변경할 비밀번호를 다시 입력하세요.'
                    ),
                    validator: (value) => value!.isEmpty ? '비밀번호를 다시 확인해 주세요.' : null,
                    controller: _checkPass,
                  ),
                  height: 40,
                  width: 240,
                ),

                Container(
                  margin: EdgeInsets.only(top:70.0, bottom: 10.0),
                  child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '저    장',
                      style: new TextStyle(fontSize: 18.0, color: Color(0xffFFFFFF), ),
                    ),
                    onPressed: (){
                      //
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

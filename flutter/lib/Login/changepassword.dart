import 'dart:ffi';

import 'package:flutter/material.dart';
import 'login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/server.dart';

class changePasswordPage extends StatefulWidget {

  final String email;
  const changePasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  State<changePasswordPage> createState() => _changePasswordPageState();
}

class _changePasswordPageState extends State<changePasswordPage> {

  final _formKey2 = new GlobalKey<FormState>();

  final TextEditingController _pass = new TextEditingController();
  final TextEditingController _checkPass = new TextEditingController();

  changePassword(String pass) async {
    if(_formKey2.currentState!.validate()){
      var url = Uri.http('${serverHttp}:8080', '/user/password/lost');

      print(widget.email);

      final data = jsonEncode({'email': widget.email, 'password': pass});

      var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json"} );

      print(response.statusCode);
      print("pass: ${pass}");
      print("data: ${data}");

      if (response.statusCode == 200) {
        print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

        var body = jsonDecode(response.body);

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);

      }
      else {
        print('error : ${response.reasonPhrase}');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(30),
            child: new Form(
                key: _formKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:80.0, bottom: 50.0),
                      child: Center(
                        child: Text(
                          '비밀번호 변경',
                          style: new TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xff4478FF) ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 5.0),
                      margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
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
                              borderSide: BorderSide(color: Color(0xff95979A), width: 2.0),
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
                      padding: EdgeInsets.only(left: 5.0),
                      margin: EdgeInsets.only(top: 25.0, bottom: 5.0),
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
                              borderSide: BorderSide(color: Color(0xff95979A), width: 2.0),
                            ),
                            hintText: '변경할 비밀번호를 다시 입력하세요.'
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "비밀번호가 확인되지 않았습니다.";
                          }
                          else if(value  != _pass.text){
                            return "비밀번호가 일치하지 않습니다.";
                          }
                          return null;
                        },
                        controller: _checkPass,
                      ),
                      height: 40,
                      width: 240,
                    ),

                    Container(
                      margin: EdgeInsets.only(top:70.0, bottom: 10.0),
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color(0xff4478FF),
                        child: new Text(
                          '저    장',
                          style: new TextStyle(fontSize: 18.0, color: Color(0xffFFFFFF), ),
                        ),
                        onPressed: (){
                          changePassword(_pass.text);
                        },
                      ),
                      height: 45,
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
                            child: Text(
                              '로그인',
                              style: TextStyle(color: Color(0xff4478FF)),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                )
            ),
          ),
        ),
      )
    );
  }
}

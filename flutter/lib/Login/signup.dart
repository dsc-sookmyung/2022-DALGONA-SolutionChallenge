import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:zerozone/Login/privacypolicy.dart';
import 'login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
    if(_formKey.currentState!.validate()){
      signUp(_email.text, _name.text, _pass.text);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
    }

  }

  Future<void> emailAuth(String email) async {

    var url = Uri.http('10.0.2.2:8080', 'email/code/send');
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


  existEmail(String email) async {

    Uri.encodeComponent(email);

    Map<String, String> _queryParameters = <String, String>{
      'email': email,
    };
    Uri.encodeComponent(email);
    var url = Uri.http('10.0.2.2:8080', '/user/email', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json"});

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);

      bool data = body["data"];

      print("data: " + data.toString());

      if(!data){
        print("중복 체크에 성공하셨습니다.");

        emailAuth(email);

      }

    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  void signUp(String email, name, pass) async {

    var url = Uri.http('10.0.2.2:8080', '/user');

    final data = jsonEncode({'email': email, 'name': name, 'password': pass});

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

  checkAuthCode(String email, authCode) async {

  var url = Uri.http('10.0.2.2:8080', '/email/code/verify');

  final data = jsonEncode({'email': email, 'authCode': authCode});

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
    return GestureDetector(
        onTap: () {
      //FocusManager.instance.primaryFocus?.unfocus();
      FocusScope.of(context).unfocus();
    },
    child:Scaffold(
      //resizeToAvoidBottomInset : false,
      body:SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
        child: new Form (
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 40.0),
                child: Center(
                  child: Text(
                    '회원가입',
                    style: new TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xff5AA9DD) ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '이메일',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0, right: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                          ),
                          // hintStyle: ,
                          hintText: '이메일을 입력하세요.'
                      ),
                      validator: (value) => value!.isEmpty ? '이메일을 입력해 주세요.' : null,
                      controller: _email,
                    ),
                    height: 40,
                    width: 240,
                  ),
                  Container(
                    //margin: EdgeInsets.only(bottom: 15.0),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0, right: 20.0),
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
                      validator: (value) => value!.isEmpty ? '인증 코드를 입력해 주세요' : null,
                      controller: _authCode,
                    ),
                    height: 40,
                    width: 240,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: RaisedButton(
                      color: Color(0xff97D5FE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '확 인',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
                      ),
                      onPressed: (){
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                      ),
                      hintText: '이름을 입력하세요.'
                  ),
                  validator: (value) => value!.isEmpty ? '이름을 입력해 주세요.' : null,
                  controller: _name,
                ),
                height: 40,
              ),

              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  '비밀번호',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                      ),
                      hintText: '비밀번호를 입력하세요.'
                  ),
                  validator: (value) => value!.isEmpty ? '비밀번호를 입력해 주세요.' : null,
                  controller: _pass,
                ),
                height: 40,
              ),

              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  '비밀번호 확인',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "비밀번호가 확인되지 않았습니다.";
                    }
                    else if(value  != _pass.text){
                      return "비밀번호가 일치하지 않습니다.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                      ),
                      hintText: '비밀번호를 입력하세요.'
                  ),
                ),
                height: 40,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                    },
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),);
                      },
                      child: Text(
                        '개인정보 이용정책',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                  ),
                  Text('에 동의합니다.'),
                ],
              ),

              Container(
                margin: EdgeInsets.only(top:10.0, bottom: 10.0),
                child: new RaisedButton(
                  color: Color(0xff97D5FE),
                  child: new Text(
                    '회원가입',
                    style: new TextStyle(fontSize: 20.0, color: Color(0xffFFFFFF), ),
                  ),
                  onPressed: (){
                    validateAndSignUp();

                    //비밀번호 확인도 여기서 확인해 주어야 함.
                  },
                ),
                height: 40,
              ),
              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('이미 계정이 있으신가요?'),
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
          ),
        )
      ),
      )
    ));
  }
}

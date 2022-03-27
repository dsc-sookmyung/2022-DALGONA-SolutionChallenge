import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';

class ModifyInformationPage extends StatefulWidget {
  const ModifyInformationPage({Key? key}) : super(key: key);

  @override
  _ModifyInformationPageState createState() => _ModifyInformationPageState();
}

class _ModifyInformationPageState extends State<ModifyInformationPage> {

  final TextEditingController _name = new TextEditingController();

  Future<void> changeName(String editName) async {

    var url = Uri.http('localhost:8080', '/user/name');
    final data = jsonEncode({'name': editName});

    name = editName;

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);
      Navigator.pop(context, editName);
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        changeName(editName);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 정보 수정',
          style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),

      body: SingleChildScrollView(
        child: Container(
        margin: EdgeInsets.only(top: 130.0, left: 40.0, right: 40.0, bottom: 130.0),
        padding: EdgeInsets.only(top: 100.0, left: 30.0, right: 30.0, bottom: 30.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Color(0xff5AA9DD),
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        height: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                '이름: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                controller: _name,
              ),
              height: 35,
            ),

            Container(
              child: RaisedButton(
                child: Text(
                    '저 장',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                onPressed: (){
                  changeName(_name.text);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Color(0xffC8E8FF),
              ),
              width: 300,
            )

          ],
        ),

      ),

    ),
    );
  }
}


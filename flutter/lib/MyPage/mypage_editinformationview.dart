import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

class ModifyInformationPage extends StatefulWidget {
  const ModifyInformationPage({Key? key}) : super(key: key);

  @override
  _ModifyInformationPageState createState() => _ModifyInformationPageState();
}

class _ModifyInformationPageState extends State<ModifyInformationPage> {
  final TextEditingController _name = new TextEditingController();

  Future<void> changeName(String editName) async {
    var url = Uri.http('${serverHttp}:8080', '/user/name');

    final data = jsonEncode({'name': editName});

    name = editName;

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);
      Navigator.pop(context, editName);
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        changeName(editName);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              children: [
                Container(
                  child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: 48.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            width: 20.0,
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context, name);
                              },
                              icon: Icon(Icons.arrow_back),
                              iconSize: 20,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            alignment: Alignment.center,
                            child: Text(
                              "내 정보 변경",
                              style: TextStyle(
                                  color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800
                              ),
                            ),

                          ),
                        ],
                      )
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      //FocusManager.instance.primaryFocus?.unfocus();
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 200.0, left: 40.0, right: 40.0, bottom: 170.0),
                      padding: EdgeInsets.only(
                          top: 50.0, left: 30.0, right: 30.0, bottom: 50.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Color(0xff4478FF),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      height: 270,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              '이름: ',
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 35.0),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                                style: TextStyle(fontSize: 17),
                              ),
                              onPressed: () {
                                if(_name.text != null && _name.text != ""){
                                  changeName(_name.text);
                                }
                                else if (_name.text == ""){
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        '이름 미입력',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      content: const Text('변경할 이름을 입력해 주세요.'),
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
                )
              ],
            ),
          )
        ));
  }
}

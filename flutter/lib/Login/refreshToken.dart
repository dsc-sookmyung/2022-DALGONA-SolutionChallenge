import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';

bool check = false;

Future<void> RefreshToken(BuildContext context) async {

  var url = Uri.http('${serverHttp}:8080', '/token/reissue/accessToken');

  final data = jsonEncode({'email': email, 'refreshToken': refreshToken});

  var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json"} );

  // print(url);
  print(response.statusCode);

  if (response.statusCode == 200) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

    var body = jsonDecode(response.body);

    if(body["state"] == 400){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
              '로그인 만료',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('로그인 유효 시간이 만료되었습니다. 다시 로그인해 주세요.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('로그인하기'),
            ),
          ],
        ),
      );
    }
    else if(body["state"] == 200){
      dynamic data = body["data"];
      String token = data["accessToken"];
      refreshToken = data["refreshToken"];

      print("token: " + token);

      if(data != "fail"){
        print("토큰 발급에 성공하셨습니다.");
        authToken = token;

        check = true;
        print("check: ${check}");
      }
    }

  }
  else {
    print(response.reasonPhrase);

  }

}


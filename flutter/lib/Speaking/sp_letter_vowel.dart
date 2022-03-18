import 'package:flutter/material.dart';
import 'package:zerozone/Login/login.dart';
import 'sp_practiceview_letter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ChooseVowelPage extends StatefulWidget {

  final String consonant;
  final int consonantIndex;

  const ChooseVowelPage({Key? key, required this.consonant, required this.consonantIndex }) : super(key: key);

  @override
  _ChooseVowelPageState createState() => _ChooseVowelPageState();
}

class _ChooseVowelPageState extends State<ChooseVowelPage> {

  List<String> vowelList = ['ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ', 'ㅐ', 'ㅔ'];

  getGridViewSelectedItem(BuildContext context, String gridItem, int index){

    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => SpLetterPracticePage(consonant: widget.consonant, consonantIndex: widget.consonantIndex, vowel: gridItem, vowelIndex: index,))
    );
  }

  void letterInfo(String gridItem, int index) async {

    Map<String, String> _queryParameters = <String, String>{
      'onsetId': widget.consonantIndex.toString(),
      'onset': widget.consonant,
      'nucleusId': index.toString(),
      'nucleus': gridItem
    };

    var url = Uri.http('localhost:8080', '/speaking/list/letter/coda', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];


    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text(
              '말하기 연습 - 한 글자',
              style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
            ),
          backgroundColor: Color(0xffC8E8FF),
          foregroundColor: Color(0xff333333),
        ),
        body: new Container(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 100.0),
          child: new Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Color(0xff5AA9DD),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  width: 300,
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10.0, bottom:30.0),
                  child: Text(
                    '선택한 자음: ${widget.consonant}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(child: GridView.count(
                crossAxisCount: 3,
                  children: vowelList.asMap().map((index,data) => MapEntry(index, GestureDetector(

                    onTap: (){
                      letterInfo(data, index+1);
                      getGridViewSelectedItem(context, data, index);
                      },
                    child: Container(

                        margin:EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration:BoxDecoration(
                            color: (index/3)%2 < 1 ? Color(0xffD8EFFF) : Color(0xff97D5FE),
                            borderRadius:BorderRadius.all(Radius.circular(15.0))
                        ) ,

                        child: Center(
                          child: Text(
                            data,
                            style: TextStyle(fontSize: 42, color: Color(0xff333333), fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),

                        ))))
                ).values.toList(),
              ),)
              ]),
        ));
  }
}

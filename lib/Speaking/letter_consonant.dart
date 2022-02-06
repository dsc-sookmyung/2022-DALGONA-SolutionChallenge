import 'package:flutter/material.dart';

class ChooseConsonantPage extends StatefulWidget {
  const ChooseConsonantPage({Key? key}) : super(key: key);

  @override
  _ChooseConsonantPageState createState() => _ChooseConsonantPageState();
}

// https://flutter-examples.com/flutter-change-listview-to-gridview/
// ToDo - 색깔 교차로 나타나도록 설정

class _ChooseConsonantPageState extends State<ChooseConsonantPage> {

  List<String> consonantList = ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];


  getGridViewSelectedItem(BuildContext context, String gridItem){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(gridItem),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text(
            '말하기 연습 - 한 글자',
            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
          ),
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Colors.black,
      ),
      body: new Container(
        padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 100.0),
        child: new Column(
            children: [ Expanded(child: GridView.count(
              crossAxisCount: 3,
              children: consonantList.map((data) => GestureDetector(


                  onTap: (){
                    getGridViewSelectedItem(context, data);
                  },
                  child: Container(

                      margin:EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration:BoxDecoration(
                          color: Color(0xffD8EFFF),
                          borderRadius:BorderRadius.all(Radius.circular(15.0))
                      ) ,

                      child: Center(
                        child: Text(
                          data,
                          style: TextStyle(fontSize: 42, color: Colors.black, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),

                      )))
              ).toList(),
            ),)
            ]),
      ));


  }
}

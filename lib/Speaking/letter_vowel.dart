import 'package:flutter/material.dart';

class ChooseVowelPage extends StatefulWidget {
  const ChooseVowelPage({Key? key}) : super(key: key);

  @override
  _ChooseVowelPageState createState() => _ChooseVowelPageState();
}

// ToDo - 색깔 교차로 나타나도록 설정 & 위에 텍스트 표시되도록 설정

class _ChooseVowelPageState extends State<ChooseVowelPage> {

  List<String> consonantList = ['ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ', 'ㅐ', 'ㅔ'];

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
        appBar: AppBar(title: Text('말하기 연습 - 한 글자')),
        body: new Container(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 100.0),
          child: new Column(
              children: [ Expanded(child: GridView.count(
                crossAxisCount: 3,
                children: consonantList.map((data) => GestureDetector(


                    onTap: (){getGridViewSelectedItem(context, data);},
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

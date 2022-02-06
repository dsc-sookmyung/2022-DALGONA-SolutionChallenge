import 'package:flutter/material.dart';

class ChooseVowelPage extends StatefulWidget {

  final String consonant;
  final int consonantIndex;
  const ChooseVowelPage({Key? key, required this.consonant, required this.consonantIndex }) : super(key: key);

  @override
  _ChooseVowelPageState createState() => _ChooseVowelPageState();
}

class _ChooseVowelPageState extends State<ChooseVowelPage> {

  List<String> vowelList = ['ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ', 'ㅐ', 'ㅔ'];

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

                    onTap: (){getGridViewSelectedItem(context, data);},
                    child: Container(

                        margin:EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration:BoxDecoration(
                            color: (index/3)%2 < 1 ? Color(0xffD8EFFF) : Color(0xff97D5FE),
                            borderRadius:BorderRadius.all(Radius.circular(15.0))
                        ) ,

                        child: Center(
                          child: Text(
                            data,
                            style: TextStyle(fontSize: 42, color: Colors.black, fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),

                        ))))
                ).values.toList(),
              ),)
              ]),
        ));
  }
}

import 'package:flutter/material.dart';

class ChooseWordConsonantPage extends StatefulWidget {
  const ChooseWordConsonantPage({Key? key}) : super(key: key);

  @override
  _ChooseWordConsonantPageState createState() => _ChooseWordConsonantPageState();
}

class _ChooseWordConsonantPageState extends State<ChooseWordConsonantPage> {

  List<String> consonantList = ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];

  getGridViewSelectedItem(BuildContext context, String gridItem, int index){
    //
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '말하기 연습 - 단어',
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
                children: consonantList.asMap().map((index,data) => MapEntry(index, GestureDetector(

                    onTap: (){
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

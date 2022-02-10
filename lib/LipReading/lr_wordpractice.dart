import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordPracticePage extends StatefulWidget {
  const WordPracticePage({Key? key}) : super(key: key);

  @override
  _WordPracticePageState createState() => _WordPracticePageState();
}

class _WordPracticePageState extends State<WordPracticePage> {
  bool _isStared = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
    child: Scaffold(
        appBar: AppBar(
          title: Text(
            "단어",
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffC8E8FF),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(left: 8.0)),
                Text(
                  "무슨 말인지 맞춰보세요!",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Padding(padding: EdgeInsets.only(right: 180.0)),
                IconButton(
                  onPressed: _pressedStar,
                  icon:
                      (_isStared ? Icon(Icons.star) : Icon(Icons.star_border)),
                  iconSize: 23,
                  color: Colors.amber,
                ),
              ],
            ),
            Image.network(
                "https://cdn.pixabay.com/photo/2020/07/27/02/09/tent-5441144_960_720.jpg",
                height: 200,
                width: 380,
                fit: BoxFit.cover),
            Padding(padding: EdgeInsets.all(3.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(left: 0.5)),
                Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(right: 5.0, left: 5.0),
                          primary: Color(0xffC8E8FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_left_sharp,
                          size: 37,
                          color: Color(0xff97D5FE),
                        ),
                        onPressed: () {}),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(right: 2.0),
                // ),
                Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffC8E8FF),
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(right: 5.0, left: 5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_right,
                          size: 37,
                          color: Color(0xff97D5FE),
                        ),
                        onPressed: () {}),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 60.0)),
                Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffC8E8FF),
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(right: 20.0, left: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("-",
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xff97D5FE),
                            )),
                        onPressed: () {}),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(right: 8.0),
                // ),
                Text("1.0", style: TextStyle()),
                // Padding(
                //   padding: EdgeInsets.only(right: 8.0),
                // ),
                Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffC8E8FF),
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 8.0, bottom: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.add_outlined,
                          size: 20,
                          color: Color(0xff97D5FE),
                        ),
                        onPressed: () {}),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 0.5)),
              ],
            ),
            Padding(padding: EdgeInsets.all(3.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '당신의 답은...',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 190.0),
                ),
                InkWell(
                  onTap: () {},
                  child: new Text(
                    "힌트 보기",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                )
              ],
            ),
            Container(
              // height: 50.0,
              margin: EdgeInsets.only(top: 8.0, left: 15.0, right: 15.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(width: 3, color: Color(0xff97D5FE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(width: 3, color: Color(0xff97D5FE)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Column(
                children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff97D5FE),
                        minimumSize: Size(90,40),
                    ),
                    onPressed: (){},
                    child: Text('확인', style: TextStyle(color: Colors.white, fontSize: 18, ),))
            ]
            ),
            Padding(padding: EdgeInsets.all(70.0)),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: EdgeInsets.only(right:8.0),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        minimumSize: Size(100,40),
                      ),
                      onPressed: (){},
                      child: Text('넘어가기', style: TextStyle(color: Color(0xff97D5FE), fontSize: 18, ),))

                ],
              ),
            ),

          ],
        )
        )
      )
    );
  }

  void _pressedStar() {
    setState(() {
      if (_isStared) {
        _isStared = false;
      } else {
        _isStared = true;
      }
    });
  }
}
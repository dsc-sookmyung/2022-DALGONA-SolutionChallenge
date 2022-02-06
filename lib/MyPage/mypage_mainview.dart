import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이 페이지'),),
      body: new Container(
        child: new Column(
          children: <Widget>[
            Container(
              child: Text('예시'),
            )
          ],
        ),
      ),
    );
  }
}

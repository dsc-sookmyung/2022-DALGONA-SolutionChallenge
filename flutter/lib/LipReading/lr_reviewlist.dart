library number_pagination;

import 'package:flutter/material.dart';
import 'package:fluttericon/brandico_icons.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/maki_icons.dart';
import 'package:fluttericon/meteocons_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:zerozone/custom_icons_icons.dart';

class ReviewListPage extends StatefulWidget {
  /// Creates a NumberPagination widget.
  const ReviewListPage({Key? key, this.date, this.title, this.icon, this.score});
  final date, title, icon, score;

  ///Trigger when page changed

  @override
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  onPageChanged(int pageNumber) {
    setState(() {
      pageInit = pageNumber;
    });
  }

  List<String> sentenceList = [
    '문장 - 안녕하세요',
    '문장 - 반가워요',
    '문장 - 안녕히가세요',
    '문장 - 좋은 하루 되세요',
    '단어 - 안녕',
    '단어 - 기러기',
    '문장 - 다음에 다시 만나요',
    '단어 - 도마',
    '단어 - 나비',
    '문장 - 좋은 아침이에요',
    '문장 - 잘 지냈어요?',
    '문장 - 요즘 뭐하고 지내요?',
    '문장 - 오랜만이에요'
  ];

  late int pageTotal=(sentenceList.length-1)~/9+1;
  int pageInit = 1;
  late int threshold = (sentenceList.length-1)~/9+1<5?
  (sentenceList.length-1)~/9+1 : 5;
  Color colorPrimary = Colors.black;
  Color colorSub = Colors.white;
  late Widget iconToFirst;
  late Widget iconPrevious;
  late Widget iconNext;
  late Widget iconToLast;
  double fontSize = 15;
  String? fontFamily;

  late int rangeStart;
  late int rangeEnd;
  late int currentPage;

  @override
  void initState() {
    currentPage = pageInit;
    iconToFirst = Icon(Icons.first_page);
    iconPrevious = Icon(Icons.keyboard_arrow_left);
    iconNext = Icon(Icons.keyboard_arrow_right);
    iconToLast = Icon(Icons.last_page);

    _rangeSet();

    super.initState();
  }

  void _changePage(int page) {
    if (page <= 0) page = 1;

    if (page > pageTotal) page = pageTotal;

    setState(() {
      currentPage = page;
      _rangeSet();
      onPageChanged(currentPage);
    });
  }

  void _rangeSet() {
    rangeStart = currentPage % threshold == 0
        ? currentPage - threshold
        : (currentPage ~/ threshold) * threshold;

    rangeEnd=((sentenceList.length).toInt()-1)~/9+1<threshold
        ? ((sentenceList.length).toInt()-1)~/9+1:
    rangeStart + threshold;
  }

  Widget _MyListView(){
    return ListView.builder(
        itemCount: currentPage==pageTotal? sentenceList.length%9: 9,
        itemBuilder: (context, idx){
          List kind=sentenceList[idx%9+9*(currentPage-1)].split('-');
          return GestureDetector(
            onTap: (){
              if(kind[0].trim()=='문장'){
                // Navigator.push(
                //     context, MaterialPageRoute(
                //     builder: (_) => ReviewListPage(date: '2022-01-29',title: sentenceList[idx%6+6*(currentPage-1)],icon: 'clean_hands',score: '34/50',)));
              }
              else if(kind[0].trim()=='단어'){

              }},
            child: Container(
              height: 48,
              margin: EdgeInsets.only(right:20.0, left: 20.0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sentenceList[idx%9+9*(currentPage-1)],
                    style: TextStyle(fontSize: 15),
                  ),
                  Icon(CustomIcons.check, color: Colors.green,)
                ],
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '기록 확인',
          style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(20.0)),
        Container(
          height: 75,
          margin: EdgeInsets.only(right:20.0, left: 20.0),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${widget.date}', style: TextStyle(fontSize: 13),),
                        Padding(padding: EdgeInsets.only(top:5.0)),
                        Text(
                          '${widget.title}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ]
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('34/50', style: TextStyle(fontSize: 15.0),)
                    ],
                  )
                ],
              ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              color: Color(0xffC8E8FF),
            ),
        ),
        Container(
            height: 470,//*((sentenceList.length-1)%10+1).toDouble(),
            child: _MyListView()
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _changePage(0),
              child: iconToFirst,
            ),
            SizedBox(
              width: 4,
            ),
            InkWell(
                onTap: () => _changePage(--currentPage), child: iconPrevious),
            SizedBox(
              width: 10,
            ),
            ...List.generate(
              rangeEnd <= pageTotal ? threshold : pageTotal % threshold,
                  (index) => Flexible(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => _changePage(index + 1 + rangeStart),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: (currentPage - 1) % threshold == index
                          ? colorPrimary
                          : colorSub,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Text(
                      '${index + 1 + rangeStart}',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        color: (currentPage - 1) % threshold == index
                            ? colorSub
                            : colorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(onTap: () => _changePage(++currentPage), child: iconNext),
            SizedBox(
              width: 4,
            ),
            InkWell(onTap: () => _changePage(pageTotal), child: iconToLast),
          ],
        ),
        Padding(padding: EdgeInsets.all(30.0))
      ]),
    );
  }
}

library number_pagination;

import 'package:flutter/material.dart';
import 'lr_reviewlist.dart';

class ReviewModePage extends StatefulWidget {
  const ReviewModePage({Key? key});

  @override
  _ReviewModePageState createState() => _ReviewModePageState();
}

class _ReviewModePageState extends State<ReviewModePage> {
  onPageChanged(int pageNumber) {
    setState(() {
      pageInit = pageNumber;
    });
  }
  // List<Map<String, String>> sentenceList=[
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  //   {'date':'2022-01-29',
  //     'title': 'test1',
  //     'total': '50',
  //     'correct': '20'},
  // ];

  List<String> sentenceList = [
    '안녕하세요',
    '반가워요',
    '안녕히가세요',
    '좋은 하루 되세요',
    '수고하셨습니다',
    '고생하셨습니다',
    '다음에 다시 만나요',
    '안녕히 주무세요',
    '어서오세요',
    '좋은 아침이에요',
    '잘 지냈어요?',
    '요즘 뭐하고 지내요?',
    '오랜만이에요',
    '안녕'
  ];

  late int pageTotal=(sentenceList.length-1)~/6+1;
  int pageInit = 1;
  late int threshold = (sentenceList.length-1)~/6+1<5?
  (sentenceList.length-1)~/6+1 : 5;
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

    rangeEnd=((sentenceList.length).toInt()-1)~/6+1<threshold
        ? ((sentenceList.length).toInt()-1)~/6+1:
    rangeStart + threshold;
  }

  Widget _MyListView(){
    return ListView.builder(
        itemCount: currentPage==pageTotal? sentenceList.length%6: 6,
        itemBuilder: (context, idx){
          return GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(
                      builder: (_) => ReviewListPage(date: '2022-01-29',title: sentenceList[idx%6+6*(currentPage-1)],icon: 'clean_hands',score: '34/50',)));
            },
            child: Container(
              height: 75,
              margin: EdgeInsets.only(right:40.0, left: 40.0),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('2022-01-29', style: TextStyle(fontSize: 13),),
                              Padding(padding: EdgeInsets.only(top:5.0)),
                              Text(
                                sentenceList[idx%6+6*(currentPage-1)],
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
                    color: Colors.black,
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
          '시험 기록',
          style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(35.0)),
        Container(
            height: 500,//*((sentenceList.length-1)%10+1).toDouble(),
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
library number_pagination;

import 'package:flutter/material.dart';

class SentenceSelectPage extends StatefulWidget {
  /// Creates a NumberPagination widget.
  const SentenceSelectPage({Key? key, this.select});
  final select;

  ///Trigger when page changed

  @override
  _SentenceSelectPageState createState() => _SentenceSelectPageState();
}

class _SentenceSelectPageState extends State<SentenceSelectPage> {
  onPageChanged(int pageNumber) {
    setState(() {
      pageInit = pageNumber;
    });
  }

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
    '오랜만이에요'
  ];

  late int pageTotal=(sentenceList.length-1)~/10+1;
  int pageInit = 1;
  late int threshold = (sentenceList.length-1)~/10+1<5?
  (sentenceList.length-1)~/10+1 : 5;
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

    rangeEnd=((sentenceList.length).toInt()-1)~/10+1<threshold
        ? ((sentenceList.length).toInt()-1)~/10+1:
        rangeStart + threshold;
  }

  Widget _sentenceBuild(int i) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.only(right:20.0, left: 20.0),
      alignment: Alignment.center,
      child: Text(
        sentenceList[i],
        style: TextStyle(fontSize: 15),
      ),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          )),
    ));
  }

  Widget _MyListView(){
    return ListView.builder(
      itemCount: currentPage==pageTotal? sentenceList.length%10: 10,
      itemBuilder: (context, idx){
      return GestureDetector(
        onTap: (){},
        child: Container(
          height: 48,
          margin: EdgeInsets.only(right:20.0, left: 20.0),
          alignment: Alignment.center,
          child: Text(
            sentenceList[idx%10+10*(currentPage-1)],
            style: TextStyle(fontSize: 15),
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
          '인사하기',
          style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
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

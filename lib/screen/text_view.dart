import 'package:ex01text_size/globals.dart';
import 'package:ex01text_size/screen/fontsize_setting_page.dart';
import 'package:flutter/material.dart';

class TextView extends StatefulWidget {
  const TextView({super.key});

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  List<String> pages = [];
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // 처음에 텍스트를 페이지로 나누기
    _splitTextIntoPages();
  }

  // 텍스트를 페이지로 나누는 함수
  void _splitTextIntoPages() {
    String content = fileContent;
    List<String> tempPages = [];
    String currentPage = '';
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,  // 줄바꿈에 영향 줄 수 있는 부분
      text: TextSpan(style: TextStyle(fontSize: fontSize), text: ''),
    );

    for (var word in content.split(RegExp(r'\s+'))) {
      // 현재 페이지에 단어를 추가해봅니다.
      String potentialPage = currentPage.isEmpty ? word : '$currentPage $word';
      textPainter.text = TextSpan(style: TextStyle(fontSize: fontSize), text: potentialPage);
      textPainter.layout(maxWidth: screenWidth);

      // 현재 제작중인 페이지 높이가 실제 폰화면 높이보다 작으면 계속 추가
      if (textPainter.height <= screenHeight * 0.6) {
        currentPage = potentialPage;
      } else {
        // 현재 페이지가 꽉 차면 페이지 리스트에 추가하고 새로운 페이지 시작
        tempPages.add(currentPage);
        currentPage = word; // 새로운 페이지는 현재 단어로 시작
        textPainter.text = TextSpan(style: TextStyle(fontSize: fontSize), text: currentPage);
        textPainter.layout(maxWidth: screenWidth);
      }
    }

    // 마지막 페이지 추가
    if (currentPage.isNotEmpty) {
      tempPages.add(currentPage);
    }

    setState(() {
      pages = tempPages; // 페이지 리스트 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(selectedFile!.name),
        actions: [
          IconButton(onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
              return Container(
                height: screenHeight*0.15, // 원하는 높이 설정
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('글씨 설정'),
                        onTap: () async {
                          // 설정 클릭 시 동작
                          final updatedFontSize = await Navigator.push(context, MaterialPageRoute(builder: (_)=>FontsizeSettingPage())); // 폰트설정 페이지로 이동
                          if (updatedFontSize != null) {
                            setState(() {
                              fontSize = updatedFontSize; // 새 폰트 사이즈 반영
                              _splitTextIntoPages(); // 페이지를 다시 나눔
                            });
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('다크/화이트 모드 전환'),
                        onTap: () {
                          // 설정 클릭 시 동작
                          Navigator.pop(context); // 모달 닫기
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            );
          }, icon:Icon(Icons.settings))
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(10),
      //   child: Text(fileContent, style: TextStyle(fontSize: fontSize),),
      // ),

      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0), // 여백 조정
            child: Text(
              pages[index],
              style: TextStyle(fontSize: fontSize),
            ),
          );
        },
      ),
    );
  }
}

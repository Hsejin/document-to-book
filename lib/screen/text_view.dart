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
    screenHeight = MediaQuery.of(context).size.height * 0.7;

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
      text: TextSpan(style: TextStyle(fontSize: fontSize), text: ''),
    );

    for (var word in content.split(' ')) {
      // 현재 페이지에 단어를 추가해봅니다.
      String potentialPage = currentPage.isEmpty ? word : '$currentPage $word';
      textPainter.text = TextSpan(style: TextStyle(fontSize: fontSize), text: potentialPage);
      textPainter.layout(maxWidth: screenWidth);

      // 현재 제작중인 페이지 높이가 실제 폰화면 높이보다 작으면 계속 추가
      if (textPainter.size.height < screenHeight) {
        currentPage = potentialPage;
      } else {
        // 현재 페이지가 꽉 차면 페이지 리스트에 추가하고 새로운 페이지 시작
        tempPages.add(currentPage);
        currentPage = word; // 새로운 페이지는 현재 단어로 시작
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
                height: screenHeight*0.2, // 원하는 높이 설정
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('글씨 설정'),
                        onTap: () {
                          // 설정 클릭 시 동작
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>FontsizeSettingPage())); // 폰트설정 페이지로 이동
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
            padding: const EdgeInsets.all(10.0), // 여백 조정
            child: SingleChildScrollView(
              child: Text(
                pages[index],
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          );
        },
      ),
    );
  }
}

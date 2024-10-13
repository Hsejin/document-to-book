import 'dart:io';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:ex01text_size/globals.dart';
import 'package:ex01text_size/screen/text_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hwp_lib/flutter_hwp_lib.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _flutterHwpLibPlugin = FlutterHwpLib();

  Future<void> pickFile() async {
    selectedFile = null;
    fileContent = '';

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // 사용자 지정 파일 형식 사용
      allowedExtensions: ['txt', 'hwp', 'doc', 'docx'], // 허용할 파일 확장자
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.single; // 선택한 파일 저장
      });

      // print(selectedFile!.name);
      // print(selectedFile!.extension);
      // print(selectedFile!.extension!.toLowerCase());
      // print(selectedFile!.path);
      // print(selectedFile!.name);

      // 파일 내용 읽기
      await readFileContent(selectedFile!.path!, selectedFile!.extension!);

      Navigator.push(context, MaterialPageRoute(builder: (_) => TextView()));
    } else {
      // 사용자가 파일 선택을 취소한 경우 처리
      setState(() {
        selectedFile = null;
        fileContent = '';
      });
    }
  }

  Future<void> readFileContent(String filePath, String ext) async {
    final file = File(filePath);

    try {
      if (ext == 'txt') {
        // 텍스트 파일 읽기
        fileContent = await file.readAsString();
      } else if (ext == 'hwp') {
        // 한글 파일 읽기
        fileContent = (await _flutterHwpLibPlugin.extractingText(filePath))!;
      } else if (ext == 'doc' || ext == 'docx') {
        // Word 파일 읽기
        final bytes = await file.readAsBytes();
        fileContent = docxToText(bytes);
      }
      fileContent = fileContent.trim();
    } catch (e) {
      print("파일 읽기 오류: $e");
      setState(() {
        fileContent = '파일을 읽는 중 오류가 발생했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  // 화면 너비와 높이를 MediaQuery로 가져오기
                  double screenWidth = MediaQuery.of(context).size.width;
                  double screenHeight = MediaQuery.of(context).size.height;

                  return SizedBox(
                    width: screenWidth * 0.8, // 화면 너비의 80%로 버튼 크기 설정
                    height: screenHeight * 0.1, // 화면 높이의 10%로 버튼 높이 설정
                    child: ElevatedButton.icon(
                      onPressed: pickFile,
                      icon: Icon(
                        Icons.file_open,
                        color: Colors.blue,
                        size: screenWidth * 0.1, // 화면 너비에 비례한 아이콘 크기
                      ),
                      label: Text(
                        "문서 찾기",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.08, // 화면 너비에 비례한 텍스트 크기
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // 모서리 곡률 설정
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.02),
                      ),
                    ),
                  );
                },
              ),
              // const SizedBox(height: 20),
              // selectedFile != null
              //     ? Text("선택된 파일: ${selectedFile!.name}   파일 내용: ${fileContent}")
              //     : Text("파일이 선택되지 않았습니다"),
            ],
          ),
        ),
      ),
    );
  }
}

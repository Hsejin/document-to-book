import 'package:ex01text_size/globals.dart';
import 'package:flutter/material.dart';

class FontsizeSettingPage extends StatefulWidget {
  const FontsizeSettingPage({super.key});

  @override
  State<FontsizeSettingPage> createState() => _FontsizeSettingPageState();
}

class _FontsizeSettingPageState extends State<FontsizeSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("글씨 설정"),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("글씨 크기", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            Row(
              children: [
                ElevatedButton(onPressed: (){
                  setState(() {
                    fontSize -= 1;
                    Navigator.pop(context, fontSize); // 현재 페이지 닫고 fontSize 전달
                  });
                }, child: const Text("-1"),),
                Text(fontSize.toInt().toString()),
                ElevatedButton(onPressed: (){
                  setState(() {
                    fontSize += 1;
                    Navigator.pop(context, fontSize); // 현재 페이지 닫고 fontSize 전달
                  });
                }, child: const Text("+1"),),
              ],
            )
          ],
        ),
      ),
    );
  }
}

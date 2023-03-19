import 'package:flutter/material.dart';
import 'package:good_morning_sunshine/src/pages/initial_page.dart';
import 'package:material_color_generator/material_color_generator.dart';

void main() {
  runApp(const GoodMorningSunshine());
}

class GoodMorningSunshine extends StatelessWidget {
  const GoodMorningSunshine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bom Dia Flor do Dia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: const Color(0xFFFEF388)),
      ),
      home: const InitialPage(),
    );
  }
}

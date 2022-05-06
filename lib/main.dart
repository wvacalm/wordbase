import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wordbase/classes/app_colors.dart';
import 'package:wordbase/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  await Hive.initFlutter();
  bool exists = await Hive.boxExists('dict');
  if (!exists) {
    var box = await Hive.openBox('dict');
    String encodedData = await rootBundle.loadString('assets/dictionary.json');
    var dictData = json.decode(encodedData);
    box.putAll(dictData);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordBase',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: AppColor.lightGrey,
            ),
        scaffoldBackgroundColor: AppColor.background,
      ),
      home: HomePage(),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wordbase/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

// import 'package:path_provider/path_provider.dart' as path_provider;

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordBase',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: const Color.fromARGB(246, 131, 124, 122),
            ),
        scaffoldBackgroundColor: const Color.fromARGB(245, 250, 226, 218),
      ),
      home: HomePage(),
    );
  }
}

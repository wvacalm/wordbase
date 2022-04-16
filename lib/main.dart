import 'package:flutter/material.dart';
import 'package:wordbase/pages/home_page.dart';

void main() {
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 13, 37, 56),
      ),
      home: HomePage(),
    );
  }
}

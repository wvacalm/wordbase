import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wordbase/classes/app_colors.dart';
import 'package:wordbase/widgets/random_button.dart';
import 'package:wordbase/widgets/result_area.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceWidth;
  final _textController = TextEditingController();
  Box? _box;
  List? _words;
  List? _filtered;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_filter);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: Hive.openBox('dict'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          _words = _box!.keys.toList();
          return GestureDetector(
              onTap: () => FocusScope.of(_context).unfocus(),
              child: displayPage());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget displayPage() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: title(),
            ),
            Flexible(
              flex: 2,
              child: searchBar(),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: ResultArea(box: _box, wordList: _filtered),
            ),
            RandomButton(box: _box, wordList: _words),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: const Text(
        "WordBase",
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget searchBar() {
    return TextField(
      enableSuggestions: false,
      controller: _textController,
      decoration: _searchBarDecoration(),
    );
  }

  void _filter() {
    var input = _textController.text.capitalize();
    setState(
      () {
        if (input == '') {
          _filtered = [];
        } else {
          _filtered = _words!.where((word) => word.contains(input)).toList();
        }
      },
    );
  }

  InputDecoration _searchBarDecoration() {
    return InputDecoration(
      border: InputBorder.none,
      filled: true,
      fillColor: AppColor.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.border,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(61.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.borderFocused,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(61.0)),
      ),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          _textController.clear();
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    } else {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
  }
}

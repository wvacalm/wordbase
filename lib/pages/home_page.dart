import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// TODO: Remove some weird words in dictionary, clean up code, how to save colors

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceWidth;
  final _textController = TextEditingController();
  Box? _box;
  List? _words;
  List? _filtered;
  int _rand = 0;

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
            _rand = Random().nextInt(_words!.length - 1);
            return GestureDetector(
                onTap: () => FocusScope.of(_context).unfocus(),
                child: displayPage());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
              child: displayTitle(),
            ),
            Flexible(
              flex: 2,
              child: search(),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: searchResults(),
            ),
            displayRandomButton(),
          ],
        ),
      ),
    );
  }

  Widget displayWord(word) {
    var def = _box!.get(word);
    return Text(
      '$word : $def',
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget displayRandomButton() {
    String randomWord = _words![_rand];
    String definition = _box!.get(randomWord);
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.shuffle,
          color: Color.fromARGB(246, 131, 124, 122),
        ),
        label: const Text(
          'Random',
          style: TextStyle(
            color: Color.fromARGB(246, 131, 124, 122),
          ),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return 1.0;
            }
            return 2.0;
          }),
          minimumSize: MaterialStateProperty.resolveWith(
            (states) => const Size(20, 1),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(245, 187, 184, 183);
              }
              return const Color.fromARGB(245, 245, 237, 234);
            },
          ),
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        onPressed: () {
          showDefinition(randomWord, definition);
          setState(
            () {
              _rand = Random().nextInt(_words!.length - 1);
            },
          );
        },
      ),
    );
  }

  void showDefinition(word, definition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(word),
        content: Text(definition),
      ),
    );
  }

  Widget search() {
    return TextField(
      enableSuggestions: false,
      controller: _textController,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: const Color.fromARGB(245, 245, 237, 234),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(0, 131, 124, 122),
          ),
          borderRadius: BorderRadius.all(Radius.circular(61.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(45, 131, 124, 122),
          ),
          borderRadius: BorderRadius.all(Radius.circular(61.0)),
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            _textController.clear();
          },
        ),
      ),
    );
  }

  Widget displaySearchBox(child) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(245, 245, 237, 234),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: child);
  }

  Widget displayResult() {
    return Scrollbar(
      isAlwaysShown: true,
      child: ListView.builder(
        itemCount: _filtered!.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              var word = _filtered![index];
              var def = _box!.get(word);
              showDefinition(word, def);
            },
            title: Text(
              _filtered![index],
            ),
          );
        },
      ),
    );
  }

  Widget searchResults() {
    if (_filtered != null) {
      if (_filtered!.isEmpty) {
        return displaySearchBox(null);
      } else {
        var resultChild = displayResult();
        return displaySearchBox(resultChild);
      }
    } else {
      return displaySearchBox(null);
    }
  }

  Widget displayTitle() {
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

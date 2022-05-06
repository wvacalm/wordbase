import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wordbase/classes/app_colors.dart';
import 'package:wordbase/classes/util.dart';

class ResultArea extends StatelessWidget {
  const ResultArea({
    Key? key,
    required this.box,
    required this.wordList,
  }) : super(key: key);
  final Box? box;
  final List? wordList;

  @override
  Widget build(BuildContext context) {
    if (wordList != null) {
      if (wordList!.isEmpty) {
        return resultBox(null);
      } else {
        var resultChild = displayResult();
        return resultBox(resultChild);
      }
    } else {
      return resultBox(null);
    }
  }

  Widget resultBox(child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: child,
    );
  }

  Widget displayResult() {
    return Scrollbar(
      isAlwaysShown: true,
      child: ListView.builder(
        itemCount: wordList!.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              var word = wordList![index];
              var def = box!.get(word);
              showDefinition(word, def, context);
            },
            title: Text(
              wordList![index],
            ),
          );
        },
      ),
    );
  }
}

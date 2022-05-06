import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wordbase/classes/app_colors.dart';
import 'package:wordbase/classes/util.dart';

class RandomButton extends StatelessWidget {
  const RandomButton({
    Key? key,
    required this.box,
    required this.wordList,
  }) : super(key: key);
  final Box? box;
  final List? wordList;

  @override
  Widget build(BuildContext context) {
    String randomWord = wordList![Random().nextInt(wordList!.length - 1)];
    String definition = box!.get(randomWord);
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        icon: _buttonIcon(),
        label: _buttonText(),
        style: _buttonStyle(),
        onPressed: () {
          showDefinition(randomWord, definition, context);
        },
      ),
    );
  }

  Icon _buttonIcon() {
    return Icon(
      Icons.shuffle,
      color: AppColor.lightGrey,
    );
  }

  Text _buttonText() {
    return Text(
      'Random',
      style: TextStyle(
        color: AppColor.lightGrey,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
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
            return AppColor.lightGrey;
          }
          return AppColor.white;
        },
      ),
      shape: MaterialStateProperty.resolveWith(
        (states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void showDefinition(word, definition, context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(word),
      content: Text(definition),
    ),
  );
}

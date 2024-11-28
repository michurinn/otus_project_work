import 'dart:convert';

import 'package:flutter/material.dart';

class RequestBodyWidget extends StatefulWidget {
  const RequestBodyWidget({
    super.key,
    this.initialText,
    this.onEditingComplete,
  });

  final Function(String)? onEditingComplete;
  final String? initialText;

  @override
  State<RequestBodyWidget> createState() => _RequestBodyWidgetState();
}

class _RequestBodyWidgetState extends State<RequestBodyWidget> {
  late String? initialText;
  @override
  void initState() {
    super.initState();
    initialText = widget.initialText ?? fixture;
    _textEditingController = TextEditingController(text: initialText);
  }

  @override
  void didUpdateWidget(covariant RequestBodyWidget oldWidget) {
    initialText = widget.initialText;
    super.didUpdateWidget(oldWidget);
  }

  late final TextEditingController _textEditingController;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        minLines: 3,
        maxLines: 12,
        decoration: const InputDecoration(
          hintText: 'Input the body text here',
          border: OutlineInputBorder(),
        ),
        controller: _textEditingController,
        onChanged: (newValue) =>
            widget.onEditingComplete?.call(_textEditingController.value.text),
      ),
    );
  }
}

final fixture = jsonEncode({
  "name": "Apple MacBook Pro 16",
  "data": {
    "year": 2019,
    "price": 1849.99,
    "CPU model": "Intel Core i9",
    "Hard disk size": "1 TB"
  }
});

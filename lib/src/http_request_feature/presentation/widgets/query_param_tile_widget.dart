import 'package:flutter/material.dart';

class QueryParamTileWidget extends StatefulWidget {
  const QueryParamTileWidget({
    super.key,
    required this.data,
    this.onEditingComplete,
  });
  final Map<String?, String?> data;
  final Function(Map<String, String>)? onEditingComplete;
  @override
  State<QueryParamTileWidget> createState() => _QueryParamTileWidgetState();
}

class _QueryParamTileWidgetState extends State<QueryParamTileWidget> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.data.keys.firstOrNull);
    _valueController =
        TextEditingController(text: widget.data.values.firstOrNull);
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Key',
              border: OutlineInputBorder(),
            ),
            controller: _keyController,
            onChanged: (newValue) => widget.onEditingComplete
                ?.call({newValue: _valueController.value.text}),
          ),
        ),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Value',
              border: OutlineInputBorder(),
            ),
            controller: _valueController,
            onSubmitted: (newValue) => widget.onEditingComplete
                ?.call({_keyController.value.text: newValue}),
          ),
        ),
      ],
    );
  }
}

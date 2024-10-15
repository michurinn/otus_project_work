import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

/// The widget contains Username & Password fields for Basic Auth options
class BasicAuthWidget extends StatefulWidget {
  const BasicAuthWidget({
    super.key,
    required this.onBaseAuthEdited,
  });
  final Function(String, String) onBaseAuthEdited;
  @override
  State<BasicAuthWidget> createState() => _BasicAuthWidgetState();
}

class _BasicAuthWidgetState extends State<BasicAuthWidget> {
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(),
              ),
              controller: _usernameController,
              onChanged: (newUser) => widget.onBaseAuthEdited
                  .call(newUser, _passwordController.value.text),
            ),
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              controller: _passwordController,
              onChanged: (newPass) => widget.onBaseAuthEdited
                  .call(_usernameController.value.text, newPass),
            ),
          ),
        ],
      ),
    );
  }
}

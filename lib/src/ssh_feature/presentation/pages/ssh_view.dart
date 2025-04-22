import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter_template/src/navigator/router.dart';

/// Displays detailed information about a SampleItem.
class SshView extends StatefulWidget {
  const SshView({super.key});

  static const routeName = '/ssh_view';

  @override
  State<SshView> createState() => _SshViewState();
}

class _SshViewState extends State<SshView> {
  late final TextEditingController _controller;
  late final TextEditingController _controllerUserName;
  late final TextEditingController _controllerPassword;
  late final TextEditingController _controllerCommand;
  final ValueNotifier<String> authSuccess = ValueNotifier('');
  SSHClient? client;
  SSHSession? shell;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: 'tty.sdf.org');
    _controllerCommand = TextEditingController();
    _controllerUserName = TextEditingController(text: 'michurinnn');
    _controllerPassword = TextEditingController(text: '96NnU9pfsalMNg');
  }

  @override
  void dispose() {
    if (client != null) {
      client!.close();
      client!.done;
    }
    _controller.dispose();
    _controllerUserName.dispose();
    _controllerPassword.dispose();
    _controllerCommand.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Ssh test'),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('History'),
              ),
              ListTile(
                title: const Text('Request 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Request 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter an url',
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Port No 22'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllerUserName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter an username',
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllerPassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a password',
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      if (client == null) {
                        client ??= SSHClient(
                          await SSHSocket.connect(_controller.value.text, 22),
                          username: _controllerUserName.value.text,
                          onPasswordRequest: () =>
                              _controllerPassword.value.text,
                          onAuthenticated: () =>
                              authSuccess.value = 'SUCCESS: AUTH',
                        );
                        shell = await client!.shell();
                        shell!.stdout.listen(
                          (data) => log(
                              String.fromCharCodes(
                                Uint8List.fromList(data),
                              ),
                              name: 'stdout stream'),
                        );
                        shell!.stderr.listen(
                          (data) => log(
                              String.fromCharCodes(
                                Uint8List.fromList(data),
                              ),
                              name: 'stderr stream'),
                        );
                      }
                    },
                    label: const Icon(
                      Icons.android_rounded,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllerCommand,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a command',
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final uints = const Utf8Encoder()
                          .convert(_controllerCommand.value.text);
                      shell?.stdin.add(uints);
                    },
                    label: const Icon(
                      Icons.woo_commerce_outlined,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder<String>(
                    valueListenable: authSuccess,
                    builder: (context, value, _) => Text(value),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) => switch (value) {
                  0 =>
                    (Router.of(context).routerDelegate as AppRouter).goToSsh(),
                  1 =>
                    (Router.of(context).routerDelegate as AppRouter).goToSse(),
                  2 =>
                    (Router.of(context).routerDelegate as AppRouter).goToApi(),
                  _ =>
                    (Router.of(context).routerDelegate as AppRouter).goToSsh(),
                },
            currentIndex: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.terminal,
                ),
                label: 'SSh',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.wind_power_sharp,
                ),
                label: 'SSe',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.data_object_rounded,
                ),
                label: 'API',
              ),
            ]),
      );
}

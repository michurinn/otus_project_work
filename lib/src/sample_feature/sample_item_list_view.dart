import 'package:flutter/material.dart';
import 'package:new_flutter_template/src/navigator/router.dart';

/// Displays a list of SampleItems.
class MainView extends StatelessWidget {
  static const routeName = '/';

  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => switch (value) {
                0 =>
                  (Router.of(context).routerDelegate as AppRouter).goToMain(),
                1 =>
                  (Router.of(context).routerDelegate as AppRouter).goToMain(),
                2 => (Router.of(context).routerDelegate as AppRouter)
                    .goToApi(),
                _ =>
                  (Router.of(context).routerDelegate as AppRouter).goToMain(),
              },
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
}

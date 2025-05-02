import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:new_flutter_template/src/navigator/navigation_state.dart';
import 'package:new_flutter_template/src/navigator/router.dart';
import 'package:new_flutter_template/src/theme/app_colors.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;
  final state = NavigationState(tab: Tabs.firest);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,
          routerDelegate: AppRouter(state: state),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: AppColors.amber,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
              },
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: AppColors.amber,
            ),
          ),
          themeMode: settingsController.themeMode,
        );
      },
    );
  }
}

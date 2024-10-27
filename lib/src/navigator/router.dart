import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_bloc.dart';
import 'package:new_flutter_template/src/navigator/navigation_state.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/pages/http_view.dart';
import 'package:new_flutter_template/src/sse_feature/data/sse_repository/sse_repository.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_bloc.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/sse_view.dart';
import 'package:new_flutter_template/src/ssh_feature/presentation/pages/ssh_view.dart';

class AppRouter extends RouterDelegate<NavigationState>
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  final NavigationState state;
  final GlobalKey<NavigatorState>? _navigatorKey = GlobalKey();

  AppRouter({required this.state});

  goToApi() {
    state.goToApi();
    notifyListeners();
  }

  goToSse() {
    state.goToSse();
    notifyListeners();
  }

  goToSsh() {
    state.goToSsh();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) => true,
      pages: [
        if (state.tab == Tabs.firest)
          MyPage(
            key: UniqueKey(),
            child: const SshView(),
          )
        else if (state.tab == Tabs.second)
          MyPage(
            key: UniqueKey(),
            child: BlocProvider<SseBloc>(
              create: (context) => SseBloc(
                sseRepository: SseRepository(),
              ),
              child: SseView(),
            ),
          )
        else
          MyPage(
            key: UniqueKey(),
            child: BlocProvider<HttpRequestFeatureBloc>(
              create: (context) => HttpRequestFeatureBloc(),
              child: HttpRequestView(),
            ),
          ),
      ],
    );
  }

  @override
  Future<bool> popRoute() async => true;

  @override
  Future<void> setNewRoutePath(configuration) {
    /// TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  @override
  get currentConfiguration => state;

  @override
  Future<void> setInitialRoutePath(configuration) {
    /// TODO: implement setInitialRoutePath
    throw UnimplementedError();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}

class MyPage extends Page {
  final Widget child;

  const MyPage({required LocalKey key, required this.child}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = .0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

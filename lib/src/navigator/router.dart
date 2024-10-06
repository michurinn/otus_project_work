import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_bloc.dart';
import 'package:new_flutter_template/src/navigator/navigation_state.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/pages/http_view.dart';
import 'package:new_flutter_template/src/sample_feature/sample_item_list_view.dart';
import 'package:new_flutter_template/src/sse_feature/data/sse_repository/sse_repository.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_bloc.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/sse_view.dart';

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

  goToMain() {
    state.goToMain();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) => true,
      pages: [
        if (state.tab == Tabs.firest)
          const MaterialPage(
            child: MainView(),
          )
        else if (state.tab == Tabs.second)
          MaterialPage(
            child: BlocProvider<SseBloc>(
              create: (context) => SseBloc(
                  sseRepository: SseRepository(
                sseClient: SSEClient(),
              )),
              child: SseView(),
            ),
          )
        else
          MaterialPage(
            child: BlocProvider<HttpRequestFeatureBloc>(
              create: (context) => HttpRequestFeatureBloc(),
              child: HttpRequestView(),
            ),
          ),
      ],
    );
  }

  @override
  Future<bool> popRoute() async {
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    /// TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  @override

  /// TODO: implement currentConfiguration
  get currentConfiguration => state;

  @override
  Future<void> setInitialRoutePath(configuration) {
    /// TODO: implement setInitialRoutePath
    throw UnimplementedError();
  }

  @override

  /// TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_bloc.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_event.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_state.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/query_params_persistent_header.dart';
import 'package:new_flutter_template/src/navigator/router.dart';
import 'package:new_flutter_template/src/share/enum/request_options_enum.dart';
import 'package:new_flutter_template/src/share/enum/request_type_enum.dart';
import 'package:new_flutter_template/src/share/widgets/animated_tab_widget.dart';

/// Displays detailed information about a SampleItem.
class HttpRequestView extends StatefulWidget {
  const HttpRequestView({super.key});

  static const routeName = '/http_request_view';

  @override
  State<HttpRequestView> createState() => _HttpRequestViewState();
}

class _HttpRequestViewState extends State<HttpRequestView>
    with TickerProviderStateMixin {
  final ValueNotifier<RequestTypeEnum> checkedType =
      ValueNotifier(RequestTypeEnum.get);

  final ValueNotifier<RequestOptionsEnum> checkedOption =
      ValueNotifier(RequestOptionsEnum.headers);

  late final TabController _controllerTab;
  late final TextEditingController _controller;
  late final TabController _requestSettingsController;
  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController(text: 'https://api.restful-api.dev/objects');
    _controllerTab =
        TabController(length: RequestTypeEnum.values.length, vsync: this);
    _requestSettingsController =
        TabController(initialIndex: 1, length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerTab.dispose();
    checkedType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('GET & POST requests'),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: TabBar(
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.blueAccent,
              splashFactory: NoSplash.splashFactory,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(
                bottom: 12.0,
                left: 12.0,
                right: 12.0,
              ),
              indicatorWeight: 0.01,
              unselectedLabelColor: Colors.grey,
              controller: _controllerTab,
              indicator: null,
              tabs: RequestTypeEnum.values
                  .map(
                    (req) => AnimatedTabWidget(
                      tabController: _controllerTab,
                      tab: MapEntry(
                        RequestTypeEnum.values.indexOf(req),
                        req.name.toUpperCase(),
                      ),
                      isActive: false,
                    ),
                  )
                  .toList(),
              onTap: (value) => switch (value) {
                0 => checkedType.value = RequestTypeEnum.get,
                1 => checkedType.value = RequestTypeEnum.post,
                _ => checkedType.value = RequestTypeEnum.get,
              },
            ),
          ),
          SliverAppBar(
            pinned: true,
            title: BlocBuilder<HttpRequestFeatureBloc, HttpRequestFeatureState>(
              builder: (context, state) {
                return TabBar(
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.greenAccent,
                  splashFactory: NoSplash.splashFactory,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.only(
                    bottom: 12.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  unselectedLabelColor: Colors.grey,
                  controller: _requestSettingsController,
                  tabs: [
                    AnimatedTabWidget(
                      tabController: _requestSettingsController,
                      tab: const MapEntry(0, 'Basic Auth'),
                      isActive:
                          state.userName != null || state.password != null,
                    ),
                    AnimatedTabWidget(
                      tabController: _requestSettingsController,
                      tab: const MapEntry(1, 'Headers'),
                      isActive:
                          state.headers != null && state.headers!.isNotEmpty,
                    ),
                    AnimatedTabWidget(
                      tabController: _requestSettingsController,
                      tab: const MapEntry(2, 'QueryParams'),
                      isActive: state.queryParams != null &&
                          state.queryParams!.isNotEmpty,
                    ),
                    AnimatedTabWidget(
                      tabController: _requestSettingsController,
                      tab: const MapEntry(3, 'Body'),
                      isActive: state.body != null && state.body!.isNotEmpty,
                    ),
                  ],
                  onTap: (value) => switch (value) {
                    0 => checkedOption.value = RequestOptionsEnum.auth,
                    1 => checkedOption.value = RequestOptionsEnum.headers,
                    2 => checkedOption.value = RequestOptionsEnum.queryParams,
                    3 => checkedOption.value = RequestOptionsEnum.body,
                    _ => checkedType.value = RequestTypeEnum.get,
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder<RequestOptionsEnum>(
            valueListenable: checkedOption,
            builder: (context, value, _) => SliverPersistentHeader(
              delegate: QueryParamsPersistentHeader(
                ticker: this,
                mode: value,
                onBodyEdited: (p0) =>
                    context.read<HttpRequestFeatureBloc>().add(
                          SetBodyDataEvent(body: p0),
                        ),
                onQueryParamsEditingComplete: (p0, p1) =>
                    context.read<HttpRequestFeatureBloc>().add(
                          SetQueryParamsEvent({p0.toString(): p1}),
                        ),
                onBaseAuthEdited: (p0, p1) =>
                    context.read<HttpRequestFeatureBloc>().add(
                          SetAuthDataEvent(
                            password: p0,
                            userName: p1,
                          ),
                        ),
                onEditingComplete: (p0, p1) {
                  context.read<HttpRequestFeatureBloc>().add(
                        SetHeadersEvent({p0.toString(): p1}),
                      );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final isValid = Uri.tryParse(_controller.value.text);
                  if (isValid == null) {
                    debugPrint('${_controller.value.text} is not valid text');
                  }
                  try {
                    final result = switch (checkedType.value) {
                      RequestTypeEnum.get => GetDataEvent(isValid!),
                      RequestTypeEnum.post => PostDataEvent(
                          isValid!,
                          {},
                        ),
                    };
                    context.read<HttpRequestFeatureBloc>().add(result);
                  } on Object catch (_) {
                    debugPrint(
                        '${_controller.value.text} has been generate Exception');
                  }
                },
                label: const Icon(
                  Icons.android_rounded,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
              child: BlocSelector<HttpRequestFeatureBloc,
                  HttpRequestFeatureState, HttpRequestFeatureState?>(
            selector: (state) {
              if (state is APISuccess || state is APIError) {
                return state;
              } else {
                return APIError(
                  message: 'None here yet...',
                  headers: state.headers,
                  password: state.password,
                  userName: state.userName,
                  queryParams: state.queryParams,
                  body: 'Error',
                );
              }
            },
            builder: (context, state) {
              return state is APISuccess
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Text(
                              'Status code ${state.statusCode}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              state.statusReason ?? '',
                            ),
                            Text(
                              state.data,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Text(
                              (state as APIError).message,
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => switch (value) {
                0 => (Router.of(context).routerDelegate as AppRouter).goToSsh(),
                1 => (Router.of(context).routerDelegate as AppRouter).goToSse(),
                2 => (Router.of(context).routerDelegate as AppRouter).goToApi(),
                _ => (Router.of(context).routerDelegate as AppRouter).goToSsh(),
              },
          currentIndex: 2,
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

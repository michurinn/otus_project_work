import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_bloc.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_event.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_state.dart';
import 'package:new_flutter_template/src/navigator/router.dart';
import 'package:new_flutter_template/src/share/enum/request_type_enum.dart';

/// Displays detailed information about a SampleItem.
class HttpRequestView extends StatelessWidget {
  HttpRequestView({super.key});

  static const routeName = '/http_request_view';
  final ValueNotifier<RequestTypeEnum?> checkedType = ValueNotifier(null);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () =>
        //       (Router.of(context).routerDelegate as AppRouter).goToMain(),
        //   icon: const Icon(
        //     Icons.arrow_back_ios,
        //   ),
        // ),
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('GET & POST requests'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            ...RequestTypeEnum.values.map(
              (req) => SliverToBoxAdapter(
                child: ListenableBuilder(
                  listenable: checkedType,
                  builder: (context, child) =>
                      RadioListTile<RequestTypeEnum?>.adaptive(
                    title: Text(req.stringRepresentation),
                    value: req,
                    groupValue: checkedType.value,
                    onChanged: (onChanged) {
                      checkedType.value = onChanged;
                    },
                  ),
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

                    /// final Uri uri = Uri.https(_controller.value.text);
                    try {
                      final result = switch (checkedType.value) {
                        RequestTypeEnum.get => GetDataEvent(isValid!),
                        RequestTypeEnum.post => PostDataEvent(
                            isValid!,
                            {},
                          ),
                        _ => null,
                      };
                      if (result is HttpRequestEvent) {
                        context.read<HttpRequestFeatureBloc>().add(result);
                      }
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
                  return APIError('Noone here yet...');
                }
              },
              builder: (context, state) {
                return state is APISuccess
                    ? Column(
                        children: [
                          Text(
                            state.statusCode.toString(),
                          ),
                          Text(
                            state.statusReason ?? '',
                          ),
                          Text(
                            state.data,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            (state as APIError).message,
                          ),
                        ],
                      );
              },
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => switch (value) {
                0 =>
                  (Router.of(context).routerDelegate as AppRouter).goToMain(),
                1 => (Router.of(context).routerDelegate as AppRouter).goToSse(),
                2 => (Router.of(context).routerDelegate as AppRouter).goToApi(),
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

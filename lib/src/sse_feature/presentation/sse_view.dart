import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:new_flutter_template/src/navigator/router.dart';
import 'package:new_flutter_template/src/share/extesnions/uri_extension.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_bloc.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_event.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_state.dart';

/// Displays detailed information about a SampleItem.
class SseView extends StatelessWidget {
  SseView({super.key});

  static const routeName = '/http_request_view';
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('SSe test'),
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
                    final uri = Uri.tryParse(_controller.value.text);
                    if (!uri.isValid) {
                      debugPrint('${_controller.value.text} is not valid text');
                    } else {
                      try {
                        context.read<SseBloc>().add(
                              SseSubscribeEvent(
                                  sseRequestType: SSERequestType.GET,
                                  url: uri!.origin,
                                  header: {}),
                            );
                      } on Object catch (_) {
                        debugPrint(
                            '${_controller.value.text} has been generate Exception');
                      }
                    }
                  },
                  label: const Icon(
                    Icons.android_rounded,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
                child: BlocSelector<SseBloc, SseState, SseSubscribedState?>(
              selector: (state) {
                if (state is SseSubscribedState) {
                  return SseSubscribedState(
                      data: state.data, event: state.event, id: state.id);
                } else if (state is SseErrorState) {
                  return SseSubscribedState(
                      data: 'Error',
                      event: 'SsZe error message',
                      id: state.message);
                } else {
                  return null;
                }
              },
              builder: (context, state) {
                return state is SseSubscribedState
                    ? Column(
                        children: [
                          Text(
                            state.id.toString(),
                          ),
                          Text(
                            state.event ?? '',
                          ),
                          Text(
                            state.data.toString(),
                          ),
                        ],
                      )
                    : const Column(
                        children: [
                          Text('Null state data'),
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

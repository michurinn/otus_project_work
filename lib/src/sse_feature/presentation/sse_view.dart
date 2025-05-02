import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:new_flutter_template/src/navigator/router.dart';
import 'package:new_flutter_template/src/share/extesnions/uri_extension.dart';
import 'package:new_flutter_template/src/share/widgets/animated_sse_message_widget.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_bloc.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_event.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_state.dart';

/// Displays detailed information about a SampleItem.
class SseView extends StatelessWidget {
  SseView({super.key});

  static const routeName = '/sse_view';
  final TextEditingController _controller =
      TextEditingController(text: 'https://sse.dev/test?interval=5');
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
                    if (uri != null && !uri.isValid) {
                      debugPrint('${_controller.value.text} is not valid text');
                    } else {
                      try {
                        context.read<SseBloc>().add(
                              SseSubscribeEvent(
                                sseRequestType: SSERequestType.GET,
                                uri: uri!,
                                header: {},
                              ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<SseBloc>().add(
                          SseCancelAllConnectionsEvent(),
                        );
                  },
                  label: const Icon(
                    Icons.cancel_outlined,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(child: BlocBuilder<SseBloc, SseState>(
              builder: (context, state) {
                return switch (state) {
                  SseSubscribedState(:final sseModel) => SingleChildScrollView(
                      child: sseModel == null
                          ? const Text('No data here...')
                          : Column(
                              children: sseModel
                                  .map(
                                    (model) => AnimatedSseMessageWidget(
                                      message: model,
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  SseConnectionClosedState(:final sseModel) => sseModel == null
                      ? const Text(
                          'The connection with Sse has been closed, no last data',
                        )
                      : Column(
                          children: [
                            const Text(
                              'The connection with Sse has been closed, the last data is:',
                            ),
                            Text(
                              sseModel.lastOrNull?.id ?? '',
                            ),
                            Text(
                              sseModel.lastOrNull?.event ?? '',
                            ),
                            Text(
                              sseModel.lastOrNull?.data ?? '',
                            ),
                          ],
                        ),
                  SseLoadingState() => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  SseErrorState(:final message) => Text(message),
                  SseInitialState() =>
                    const Text('You would see Sse events here'),
                };
              },
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => switch (value) {
                0 => (Router.of(context).routerDelegate as AppRouter).goToSsh(),
                1 => (Router.of(context).routerDelegate as AppRouter).goToSse(),
                2 => (Router.of(context).routerDelegate as AppRouter).goToApi(),
                _ => (Router.of(context).routerDelegate as AppRouter).goToSsh(),
              },
          currentIndex: 1,
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

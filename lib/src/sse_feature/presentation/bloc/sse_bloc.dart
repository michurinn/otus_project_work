import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:new_flutter_template/src/sse_feature/domain/i_sse_repository.dart';

import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_event.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_state.dart';

class SseBloc extends Bloc<SseEvent, SseState> {
  SseBloc({required this.sseRepository}) : super(SseInitialState()) {
    on<SseSubscribeEvent>(_handleSubscribeRequest);
    on<SseDataRecievedEvent>(_handleDataRecievedRequest);
    on<SseCancelAllConnectionsEvent>(_handleCloseAllConnectionsRequest);
  }

  final ISseRepository sseRepository;
  StreamSubscription? sseStreamSubscription;
  Stream<SSEModel>? sseStream;

  // Handling Subscribe request
  Future<void> _handleSubscribeRequest(
      SseSubscribeEvent event, Emitter<SseState> emit) async {
    try {
      sseStream = sseRepository.getSseStream(
        type: event.sseRequestType,
        uri: event.uri,
        header: event.header,
      );
      sseStreamSubscription = sseStream?.listen(
        (data) => add(
          SseDataRecievedEvent(
            sseModel: data,
          ),
        ),
        onDone: () {
          emit(
            SseConnectionClosedState(
              sseModel: state is SseSubscribedState
                  ? (state as SseSubscribedState).sseModel
                  : null,
            ),
          );
        },
        onError: (e, s) => emit(
          SseErrorState('The error has occured into SSe stream'),
        ),
      );
    } catch (e) {
      emit(SseErrorState('Error: $e'));
    }
  }

  // Handling Close all connections request
  Future<void> _handleCloseAllConnectionsRequest(
      SseCancelAllConnectionsEvent event, Emitter<SseState> emit) async {
    try {
      sseRepository.cancelSseStream();
      if (sseStreamSubscription != null) {
        await sseStreamSubscription!.cancel();
      }
    } catch (e) {
      emit(SseErrorState('Error: $e'));
    }
  }

  // Handling Data Recieved request
  Future<void> _handleDataRecievedRequest(
      SseDataRecievedEvent event, Emitter<SseState> emit) async {
    final List<SSEModel>? resultingList = switch (state) {
      SseInitialState() => [event.sseModel],
      SseLoadingState() => [event.sseModel],
      SseSubscribedState() => (state as SseSubscribedState).sseModel == null
          ? [event.sseModel]
          : List.from((state as SseSubscribedState).sseModel!)
        ..add(event.sseModel),
      SseErrorState() => [event.sseModel],
      SseConnectionClosedState() => null,
    };

    if (resultingList != null) {
      emit(
        SseSubscribedState(
          sseModel: resultingList,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    sseRepository.cancelSseStream();
    await sseStreamSubscription?.cancel();
    return super.close();
  }

  @override
  void onChange(Change<SseState> change) {
    log(change.nextState.runtimeType.toString(),
        name: 'Sse bloc has been changed');
    if (change.nextState is SseSubscribedState) {
      log((change.nextState as SseSubscribedState).sseModel.toString(),
          name: 'list, Sse bloc has been changed');
    }
    super.onChange(change);
  }
}

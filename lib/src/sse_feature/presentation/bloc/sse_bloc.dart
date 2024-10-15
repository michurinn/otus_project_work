import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:new_flutter_template/src/sse_feature/domain/i_sse_repository.dart';

import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_event.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_state.dart';

class SseBloc extends Bloc<SseEvent, SseState> {
  SseBloc({required this.sseRepository}) : super(SseInitialState()) {
    on<SseSubscribeEvent>(_handleSubscribeRequest);
    on<SseUnsubscribeEvent>(_handlrUnsubscribeRequest);
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
        url: event.url,
        header: event.header,
      );
      sseStreamSubscription = sseStream?.listen(
        (data) => add(
          SseDataRecievedEvent(
            sseModel: data,
          ),
        ),
        onDone: () {
          /// TODO(me): onDone callback really doesnt work
          debugPrint('StreamSubscription has been closed');
          emit(
            SseConnectionClosedState(
              sseModel: state is SseSubscribedState
                  ? (state as SseSubscribedState).sseModel
                  : null,
            ),
          );
        },
        onError: (e,s)=>  emit(
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

  // Handling Unsubscribe request
  Future<void> _handlrUnsubscribeRequest(
      SseUnsubscribeEvent event, Emitter<SseState> emit) async {
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
    emit(
      SseSubscribedState(
        sseModel: event.sseModel,
      ),
    );
  }

  @override
  Future<void> close() async {
    await sseStreamSubscription?.cancel();
    return super.close();
  }
}

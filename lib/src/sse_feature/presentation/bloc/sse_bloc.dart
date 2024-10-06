import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:new_flutter_template/src/sse_feature/domain/i_sse_repository.dart';

import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_event.dart';
import 'package:new_flutter_template/src/sse_feature/presentation/bloc/sse_state.dart';

class SseBloc extends Bloc<SseEvent, SseState> {
  SseBloc({required this.sseRepository}) : super(SseInitialState()) {
    on<SseSubscribeEvent>(_handleSubscribeRequest);
    on<SseUnsubscribeEvent>(_handlrUnsubscribeRequest);
    on<SseDataRecievedEvent>(_handleDataRecievedRequest);
  }

  final ISseRepository sseRepository;
  StreamSubscription? sseStreamSubscription;

  // Handling Subscribe request
  Future<void> _handleSubscribeRequest(
      SseSubscribeEvent event, Emitter<SseState> emit) async {
    try {
      sseStreamSubscription = sseRepository
          .getSseStream(
            type: event.sseRequestType,
            url: event.url,
            header: event.header,
          )
          .listen(
            (data) => add(
              SseDataRecievedEvent(
                event: data.event,
                data: data.data,
                id: data.id,
              ),
            ),
          );
    } catch (e) {
      emit(SseErrorState('Error: $e'));
    }
  }

  // Handling Unsubscribe request
  Future<void> _handlrUnsubscribeRequest(
      SseUnsubscribeEvent event, Emitter<SseState> emit) async {
    try {
      if (sseStreamSubscription != null) {
        sseStreamSubscription!.cancel();
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
        event: event.event,
        data: event.data,
        id: event.id,
      ),
    );
  }

  @override
  Future<void> close() {
    sseStreamSubscription?.cancel();
    return super.close();
  }
}

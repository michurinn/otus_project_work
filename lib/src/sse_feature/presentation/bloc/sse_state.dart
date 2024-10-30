// APIState sealed class manages various API request states
import 'package:flutter_client_sse/flutter_client_sse.dart';

sealed class SseState {}

class SseInitialState extends SseState {}

class SseLoadingState extends SseState {}

class SseSubscribedState extends SseState {
  final List<SSEModel>? sseModel;
  SseSubscribedState({
    required this.sseModel,
  });
}

class SseErrorState extends SseState {
  final String message;
  SseErrorState(this.message);
}

class SseConnectionClosedState extends SseState {
  final List<SSEModel>? sseModel;
  SseConnectionClosedState({
    required this.sseModel,
  });
}

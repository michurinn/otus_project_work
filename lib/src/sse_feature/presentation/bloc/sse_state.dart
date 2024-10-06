// APIState sealed class manages various API request states
sealed class SseState {}

class SseInitialState extends SseState {}

class SseLoadingState extends SseState {}

class SseSubscribedState extends SseState {
  final String? id;
  final String? data;
  final String? event;
  SseSubscribedState({
    required this.id,
    required this.data,
    required this.event,
  });
}

class SseErrorState extends SseState {
  final String message;
  SseErrorState(this.message);
}

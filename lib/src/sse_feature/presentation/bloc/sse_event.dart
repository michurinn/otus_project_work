// SseSubscribeEvent is sealed, so you can only extend from it within this file.
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

sealed class SseEvent {}

class SseSubscribeEvent extends SseEvent {
  final SSERequestType sseRequestType;
  final String url;
  final Map<String, String> header;

  SseSubscribeEvent({
    required this.sseRequestType,
    required this.url,
    required this.header,
  });
}

class SseDataRecievedEvent extends SseEvent {
  final SSEModel sseModel;

  SseDataRecievedEvent({
    required this.sseModel,
  });
}

class SseCancelAllConnectionsEvent extends SseEvent {
  SseCancelAllConnectionsEvent();
}

/// Unsubscribe from one avaiable sse connection
class SseUnsubscribeEvent extends SseEvent {
  SseUnsubscribeEvent();
}

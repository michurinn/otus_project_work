import 'dart:async';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:new_flutter_template/src/share/network/otus_sse_client.dart';
import 'package:new_flutter_template/src/sse_feature/domain/i_sse_repository.dart';

class SseRepository implements ISseRepository {
  @override
  Stream<SSEModel> getSseStream({
    required SSERequestType type,
    required String url,
    required Map<String, String> header,
  }) {
    ///GET REQUEST
    return OtusSSEClient.subscribeToSSE(
      method: type,
      url: url,
      header: header,
    );
  }

  @override
  void cancelSseStream() {
    OtusSSEClient.unsubscribeFromSSE();
  }
}

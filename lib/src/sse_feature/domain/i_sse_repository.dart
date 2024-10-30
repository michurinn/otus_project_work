import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

/// The repository for work with SSE connections
abstract class ISseRepository {
  Stream<SSEModel> getSseStream({
    required SSERequestType type,
    required Uri uri,
    required Map<String, String> header,
  });

  void cancelSseStream();
}

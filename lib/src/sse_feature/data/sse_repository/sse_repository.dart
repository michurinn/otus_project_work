import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:new_flutter_template/src/sse_feature/domain/i_sse_repository.dart';

class SseRepository implements ISseRepository {
  final SSEClient sseClient;

  SseRepository({required this.sseClient});
  @override
  Stream<SSEModel> getSseStream({
    required SSERequestType type,
    required String url,
    required Map<String, String> header,
  }) {
    ///GET REQUEST
    return SSEClient.subscribeToSSE(
      method: type,
      url: url,
      header: header,
      // {
      //   "Cookie":
      //       'jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
      //   "Accept": "text/event-stream",
      //   "Cache-Control": "no-cache",
      // },
    );
  }
}

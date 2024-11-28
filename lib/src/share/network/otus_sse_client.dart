library flutter_client_sse;

import 'dart:async';
import 'dart:convert';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;

/// A client for subscribing to Server-Sent Events (SSE).
class OtusSSEClient {
  static http.Client _client = http.Client();

  /// Retry the SSE connection after a delay.
  ///
  /// [method] is the request method (GET or POST).
  /// [url] is the URL of the SSE endpoint.
  /// [header] is a map of request headers.
  /// [body] is an optional request body for POST requests.
  /// [streamController] is required to persist the stream from the old connection
  static void _retryConnection(
      {required SSERequestType method,
      required Uri uri,
      required Map<String, String> header,
      required StreamController<SSEModel> streamController,
      Map<String, dynamic>? body}) {}

  /// Subscribe to Server-Sent Events.
  ///
  /// [method] is the request method (GET or POST).
  /// [url] is the URL of the SSE endpoint.
  /// [header] is a map of request headers.
  /// [body] is an optional request body for POST requests.
  ///
  /// Returns a [Stream] of [SSEModel] representing the SSE events.
  static Stream<SSEModel> subscribeToSSE(
      {required SSERequestType method,
      required Uri uri,
      required Map<String, String> header,
      StreamController<SSEModel>? oldStreamController,
      Map<String, dynamic>? body}) {
    StreamController<SSEModel> streamController = StreamController();
    if (oldStreamController != null) {
      streamController = oldStreamController;
    }
    var lineRegex = RegExp(r'^([^:]*)(?::)?(?: )?(.*)?$');
    var currentSSEModel = SSEModel(data: '', id: '', event: '');
    while (true) {
      try {
        _client = http.Client();
        var request = http.Request(
          method == SSERequestType.GET ? "GET" : "POST",
          uri,
        );

        /// Adding headers to the request
        header.forEach((key, value) {
          request.headers[key] = value;
        });

        /// Adding body to the request if exists
        if (body != null) {
          request.body = jsonEncode(body);
        }

        Future<http.StreamedResponse> response = _client.send(request);

        /// Listening to the response as a stream
        response.asStream().listen((data) {
          /// Applying transforms and listening to it
          data.stream
            ..transform(const Utf8Decoder())
                .transform(const LineSplitter())
                .listen(
              (dataLine) {
                if (dataLine.isEmpty) {
                  /// This means that the complete event set has been read.
                  /// We then add the event to the stream
                  streamController.add(currentSSEModel);
                  currentSSEModel = SSEModel(data: '', id: '', event: '');
                  return;
                }

                /// Get the match of each line through the regex
                Match match = lineRegex.firstMatch(dataLine)!;
                var field = match.group(1);
                if (field!.isEmpty) {
                  return;
                }
                var value = '';
                if (field == 'data') {
                  // If the field is data, we get the data through the substring
                  value = dataLine.substring(
                    5,
                  );
                } else {
                  value = match.group(2) ?? '';
                }
                switch (field) {
                  case 'event':
                    currentSSEModel.event = value;
                    break;
                  case 'data':
                    currentSSEModel.data =
                        '${currentSSEModel.data ?? ''}$value\n';
                    break;
                  case 'id':
                    currentSSEModel.id = value;
                    break;
                  case 'retry':
                    break;
                  default:
                    _retryConnection(
                      method: method,
                      uri: uri,
                      header: header,
                      streamController: streamController,
                    );
                }
              },
              onError: (e, s) {
                _retryConnection(
                  method: method,
                  uri: uri,
                  header: header,
                  body: body,
                  streamController: streamController,
                );
              },
            );
        }, onError: (e, s) {
          _retryConnection(
            method: method,
            uri: uri,
            header: header,
            body: body,
            streamController: streamController,
          );
        });
      } catch (e) {
        _retryConnection(
          method: method,
          uri: uri,
          header: header,
          body: body,
          streamController: streamController,
        );
      }
      return streamController.stream;
    }
  }

  /// Unsubscribe from the SSE.
  static void unsubscribeFromSSE() {
    _client.close();
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_event.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_state.dart';
import 'package:new_flutter_template/src/share/typedefs/typedef_json.dart';

class HttpRequestFeatureBloc
    extends Bloc<HttpRequestEvent, HttpRequestFeatureState> {
  HttpRequestFeatureBloc()
      : super(
          const APIInitial(
            headers: null,
            userName: null,
            password: null,
          ),
        ) {
    on<GetDataEvent>(_handleGetRequest);
    on<PostDataEvent>(_handlePostRequest);
    on<SetDataEvent>(_handleSetDataEvent);
    on<SetAuthDataEvent>(_handleSetAuthDataEvent);
  }

  // Handling Set Basic Auth info
  Future<void> _handleSetAuthDataEvent(
      SetAuthDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    emit(
      APIReady(
        headers: state.headers,
        password: event.password,
        userName: event.userName,
      ),
    );
  }

  // Handling Set request Headers
  Future<void> _handleSetDataEvent(
      SetDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    /// Modify headers with the actual event
    var newHeaders = state.headers ?? <String, Json>{};
    for (var element in event.parameters.keys) {
      newHeaders[element] = event.parameters[element] ?? {};
    }
    emit(
      APIReady(
        headers: newHeaders,
        password: state.password,
        userName: state.userName,
      ),
    );
  }

  // Handling GET request
  Future<void> _handleGetRequest(
      GetDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    final headers = (state is APIReady) ? (state as APIReady).headers : null;
    emit(
      APILoading(
        headers: state.headers,
        userName: state.userName,
        password: state.password,
      ),
    );
    final Map<String, String> calculatedHeaders = headers == null
        ? {}
        : headers.map(
            (_, data) => MapEntry(
              data.keys.first,
              data.values.first.toString(),
            ),
          );
    try {
      Map<String, String> basicAuth = {
        'authorization': 'Basic ${base64.encode(
          utf8.encode(
            '${state.userName}:${state.password}',
          ),
        )}'
      };
      debugPrint(
        basicAuth.toString(),
      );

      final response = await http.get(
        event.url,
        headers: calculatedHeaders..addAll(basicAuth),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(
          APISuccess(
            headers: state.headers,
            statusCode: response.statusCode,
            data: data.toString(),
            statusReason: response.reasonPhrase,
            password: state.password,
            userName: state.userName,
          ),
        );
      } else {
        emit(
          APIError(
            headers: state.headers,
            message: 'Failed to fetch data: ${response.statusCode}',
            password: state.password,
            userName: state.userName,
          ),
        );
      }
    } catch (e) {
      emit(
        APIError(
          headers: state.headers,
          message: 'Error: $e',
          password: state.password,
          userName: state.userName,
        ),
      );
    }
  }

  // Handling POST request
  Future<void> _handlePostRequest(
      PostDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    emit(
      APILoading(
        headers: state.headers,
        userName: state.userName,
        password: state.password,
      ),
    );
    try {
      final response = await http.post(
        event.url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event.body),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        emit(
          APISuccess(
            headers: state.headers,
            statusCode: response.statusCode,
            data: data.toString(),
            statusReason: response.reasonPhrase,
            password: state.password,
            userName: state.userName,
          ),
        );
      } else {
        emit(
          APIError(
            headers: state.headers,
            password: state.password,
            userName: state.userName,
            message: 'Failed to post data: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      emit(
        APIError(
          headers: state.headers,
          message: 'Error: $e',
          password: state.password,
          userName: state.userName,
        ),
      );
    }
  }

  @override
  void onChange(Change<HttpRequestFeatureState> change) {
    debugPrint(
      change.toString(),
    );
    super.onChange(change);
  }
}

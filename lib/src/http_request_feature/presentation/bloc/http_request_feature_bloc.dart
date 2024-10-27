import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hello/hello_method_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_event.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_state.dart';
import 'package:new_flutter_template/src/share/extesnions/uri_extension.dart';
import 'package:new_flutter_template/src/share/typedefs/typedef_json.dart';

class HttpRequestFeatureBloc
    extends Bloc<HttpRequestEvent, HttpRequestFeatureState> {
  HttpRequestFeatureBloc()
      : super(
          const APIInitial(
            headers: null,
            userName: null,
            password: null,
            queryParams: null,
            body: null,
          ),
        ) {
    on<GetDataEvent>(_handleGetRequest);
    on<PostDataEvent>(_handlePostRequest);
    on<SetHeadersEvent>(_handleSeHeadersEvent);
    on<SetQueryParamsEvent>(_handleSetQueryParamsEvent);
    on<SetAuthDataEvent>(_handleSetAuthDataEvent);
    on<SetBodyDataEvent>(_handleSetBodyDataEvent);
  }

  /// The method for checking Internet connection active status
  final c = MethodChannelHello();

  // Handling Set Basic Auth info
  Future<void> _handleSetAuthDataEvent(
      SetAuthDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    emit(
      APIReady(
        headers: state.headers,
        password: event.password,
        userName: event.userName,
        queryParams: state.queryParams,
        body: state.body,
      ),
    );
  }

  // Handling Set Body info
  Future<void> _handleSetBodyDataEvent(
      SetBodyDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    emit(
      APIReady(
        headers: state.headers,
        password: state.password,
        userName: state.userName,
        queryParams: state.queryParams,
        body: event.body,
      ),
    );
  }

  // Handling Set request Query
  Future<void> _handleSetQueryParamsEvent(
      SetQueryParamsEvent event, Emitter<HttpRequestFeatureState> emit) async {
    /// Modify headers with the actual event
    var newQuery = state.queryParams ?? <String, Json>{};
    for (var element in event.parameters.keys) {
      newQuery[element] = event.parameters[element] ?? {};
    }
    emit(
      APIReady(
        headers: state.headers,
        password: state.password,
        userName: state.userName,
        queryParams: newQuery,
        body: state.body,
      ),
    );
  }

  // Handling Set request Headers
  Future<void> _handleSeHeadersEvent(
      SetHeadersEvent event, Emitter<HttpRequestFeatureState> emit) async {
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
        queryParams: state.queryParams,
        body: state.body,
      ),
    );
  }

  // Handling GET request
  Future<void> _handleGetRequest(
      GetDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    final headers = state.headers;
    final query = state.queryParams;
    emit(
      APILoading(
        headers: state.headers,
        userName: state.userName,
        password: state.password,
        queryParams: state.queryParams,
        body: state.body,
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
    final Map<String, String> calculatedQueries = query == null
        ? {}
        : query.map(
            (_, data) => MapEntry(
              data.keys.first,
              data.values.first.toString(),
            ),
          );
    try {
      Map<String, String> basicAuth = {
        'Authorization': 'Basic ${base64.encode(
          utf8.encode(
            '${state.userName}:${state.password}',
          ),
        )}'
      };
      if (await c.checkNetworkConnectionStatus() == false) {
        emit(
          APIError(
            headers: state.headers,
            password: state.password,
            userName: state.userName,
            message: 'Please, try your internet connection',
            queryParams: state.queryParams,
            body: state.body,
          ),
        );
        return;
      }

      final response = await http.get(
        event.url..addQueryParams(calculatedQueries),
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
            queryParams: state.queryParams,
            body: state.body,
          ),
        );
      } else {
        emit(
          APIError(
            headers: state.headers,
            message: 'Failed to fetch data: ${response.statusCode}',
            password: state.password,
            userName: state.userName,
            queryParams: state.queryParams,
            body: state.body,
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
          queryParams: state.queryParams,
          body: state.body,
        ),
      );
    }
  }

  // Handling POST request
  Future<void> _handlePostRequest(
      PostDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    final headers = (state is APIReady) ? (state as APIReady).headers : null;
    final query = (state is APIReady) ? (state as APIReady).queryParams : null;
    emit(
      APILoading(
        headers: state.headers,
        userName: state.userName,
        password: state.password,
        queryParams: state.queryParams,
        body: state.body,
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
    final Map<String, String> calculatedQueries = query == null
        ? {}
        : query.map(
            (_, data) => MapEntry(
              data.keys.first,
              data.values.first.toString(),
            ),
          );
    try {
      Map<String, String> basicAuth = {
        'Authorization': 'Basic ${base64.encode(
          utf8.encode(
            '${state.userName}:${state.password}',
          ),
        )}'
      };
      debugPrint(
        basicAuth.toString(),
      );

      if (await c.checkNetworkConnectionStatus() == false) {
        emit(
          APIError(
            headers: state.headers,
            password: state.password,
            userName: state.userName,
            message: 'Please, try your internet connection',
            queryParams: state.queryParams,
            body: state.body,
          ),
        );
        return;
      }

      final response = await http.post(
        event.url..addQueryParams(calculatedQueries),
        headers: calculatedHeaders
          ..addAll(basicAuth)
          ..addAll({'content-type': 'application/x-www-form-urlencoded'}),
        body: state.body == null ? null : jsonDecode(state.body!),
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
            queryParams: state.queryParams,
            body: state.body,
          ),
        );
      } else {
        emit(
          APIError(
            headers: state.headers,
            password: state.password,
            userName: state.userName,
            message: 'Failed to post data: ${response.statusCode}',
            queryParams: state.queryParams,
            body: state.body,
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
          queryParams: state.queryParams,
          body: state.body,
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

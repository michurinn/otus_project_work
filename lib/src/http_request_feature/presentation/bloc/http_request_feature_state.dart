// APIState sealed class manages various API request states

import 'package:equatable/equatable.dart';
import 'package:new_flutter_template/src/share/typedefs/typedef_json.dart';

sealed class HttpRequestFeatureState extends Equatable {
  final Map<String, Json>? headers;
  final Map<String, Json>? queryParams;
  final String? userName;
  final String? password;
  final String? body;

  const HttpRequestFeatureState({
    required this.headers,
    required this.password,
    required this.userName,
    required this.queryParams,
    required this.body,
  });
}

class APIInitial extends HttpRequestFeatureState {
  const APIInitial({
    required super.headers,
    required super.password,
    required super.userName,
    required super.queryParams,
    required super.body,
  });

  APIInitial copyWith({
    final Map<String, Json>? headers,
    final Map<String, Json>? queryParams,
    final String? userName,
    final String? password,
    final String? body,
  }) {
    return APIInitial(
      headers: headers ?? this.headers,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      queryParams: queryParams ?? this.queryParams,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props => [headers, password, userName, queryParams, body];
}

class APILoading extends HttpRequestFeatureState {
  const APILoading({
    required super.headers,
    required super.password,
    required super.userName,
    required super.queryParams,
    required super.body,
  });

  APILoading copyWith({
    final Map<String, Json>? headers,
    final Map<String, Json>? queryParams,
    final String? userName,
    final String? password,
    final String? body,
  }) {
    return APILoading(
      headers: headers ?? this.headers,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      queryParams: queryParams ?? this.queryParams,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props => [headers, password, userName, queryParams, body];
}

class APIReady extends HttpRequestFeatureState {
  const APIReady({
    required super.headers,
    required super.password,
    required super.userName,
    required super.queryParams,
    required super.body,
  });

  APIReady copyWith({
    final Map<String, Json>? headers,
    final Map<String, Json>? queryParams,
    final String? userName,
    final String? password,
    final String? body,
  }) {
    return APIReady(
      headers: headers ?? this.headers,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      queryParams: queryParams ?? this.queryParams,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props => [headers, password, userName, queryParams, body];
}

class APISuccess extends HttpRequestFeatureState {
  final int statusCode;
  final String? statusReason;
  final String data;
  const APISuccess({
    required this.statusCode,
    required this.statusReason,
    required this.data,
    required super.headers,
    required super.password,
    required super.userName,
    required super.queryParams,
    required super.body,
  });

  APISuccess copyWith({
    final Map<String, Json>? headers,
    final Map<String, Json>? queryParams,
    final String? userName,
    final String? password,
    final int? statusCode,
    final String? statusReason,
    final String? data,
    final String? body,
  }) {
    return APISuccess(
      headers: headers ?? this.headers,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      queryParams: queryParams ?? this.queryParams,
      statusCode: statusCode ?? this.statusCode,
      statusReason: statusReason ?? this.statusReason,
      data: data ?? this.data,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props => [
        statusCode,
        statusReason,
        data,
        headers,
        password,
        userName,
        queryParams,
        body,
      ];
}

class APIError extends HttpRequestFeatureState {
  final String message;

  const APIError({
    required super.headers,
    required this.message,
    required super.password,
    required super.userName,
    required super.queryParams,
    required super.body,
  });

  APIError copyWith({
    final Map<String, Json>? headers,
    final Map<String, Json>? queryParams,
    final String? userName,
    final String? password,
    final String? message,
    final String? body,
  }) {
    return APIError(
      headers: headers ?? this.headers,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      queryParams: queryParams ?? this.queryParams,
      message: message ?? this.message,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props =>
      [message, headers, password, userName, queryParams, body];
}

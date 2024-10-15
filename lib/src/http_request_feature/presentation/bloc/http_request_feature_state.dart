// APIState sealed class manages various API request states

import 'package:equatable/equatable.dart';
import 'package:new_flutter_template/src/share/typedefs/typedef_json.dart';

sealed class HttpRequestFeatureState extends Equatable {
  final Map<String, Json>? headers;
  final String? userName;
  final String? password;
  const HttpRequestFeatureState({
    required this.headers,
    required this.password,
    required this.userName,
  });
}

class APIInitial extends HttpRequestFeatureState {
  const APIInitial(
      {required super.headers,
      required super.password,
      required super.userName});

  @override
  List<Object?> get props => [headers];
}

class APILoading extends HttpRequestFeatureState {
  const APILoading(
      {required super.headers,
      required super.password,
      required super.userName});

  @override
  List<Object?> get props => [headers];
}

class APIReady extends HttpRequestFeatureState {
  const APIReady(
      {required super.headers,
      required super.password,
      required super.userName});

  @override
  List<Object?> get props => [headers];
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
  });

  @override
  List<Object?> get props => [statusCode, statusReason, data];
}

class APIError extends HttpRequestFeatureState {
  final String message;
  const APIError(
      {required super.headers,
      required this.message,
      required super.password,
      required super.userName});

  @override
  List<Object?> get props => [message];
}

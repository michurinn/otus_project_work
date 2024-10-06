// APIState sealed class manages various API request states
sealed class HttpRequestFeatureState {}

class APIInitial extends HttpRequestFeatureState {}

class APILoading extends HttpRequestFeatureState {}

class APISuccess extends HttpRequestFeatureState {
  final int statusCode;
  final String? statusReason;
  final String data;
  APISuccess({
    required this.statusCode,
    required this.statusReason,
    required this.data,
  });
}

class APIError extends HttpRequestFeatureState {
  final String message;
  APIError(this.message);
}

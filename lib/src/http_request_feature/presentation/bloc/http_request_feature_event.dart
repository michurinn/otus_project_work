// APIEvent is sealed, so you can only extend from it within this file.
import 'package:new_flutter_template/src/share/typedefs/typedef_json.dart';

sealed class HttpRequestEvent {}

class GetDataEvent extends HttpRequestEvent {
  final Uri url;
  GetDataEvent(this.url);
}

class PostDataEvent extends HttpRequestEvent {
  final Uri url;
  final Map<String, dynamic> body;
  PostDataEvent(this.url, this.body);
}

/// Keep the Auth data here
class SetAuthDataEvent extends HttpRequestEvent {
  final String? userName;
  final String? password;

  SetAuthDataEvent({
    required this.userName,
    required this.password,
  });
}

/// Keep the Body data here
class SetBodyDataEvent extends HttpRequestEvent {
  final String? body;

  SetBodyDataEvent({
    required this.body,
  });
}

class SetHeadersEvent extends HttpRequestEvent {
  /// The information about the headers
  /// Uses the key for determining the uniqueness of the header
  /// To store the key value of the header
  /// In another case, there may be collisions when entering from the form
  /// (for example, when entering 'coo' and completing editing and then returning and editing in the cookie field,
  /// both keys could be created)
  final Map<String, Json> parameters;
  SetHeadersEvent(this.parameters);
}

class SetQueryParamsEvent extends HttpRequestEvent {
  /// The information about the query parameters
  /// Uses the key for determining the uniqueness of the parameter
  /// To store the key value of the parameter
  /// In another case, there may be collisions when entering from the form
  /// (for example, when entering 'i' and completing editing and then returning and editing in the id field,
  /// both keys could be created)
  final Map<String, Json> parameters;
  SetQueryParamsEvent(this.parameters);
}

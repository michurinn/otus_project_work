// APIEvent is sealed, so you can only extend from it within this file.
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

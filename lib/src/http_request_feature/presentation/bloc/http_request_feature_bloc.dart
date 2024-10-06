import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_event.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_state.dart';

class HttpRequestFeatureBloc
    extends Bloc<HttpRequestEvent, HttpRequestFeatureState> {
  HttpRequestFeatureBloc() : super(APIInitial()) {
    on<GetDataEvent>(_handleGetRequest);
    on<PostDataEvent>(_handlePostRequest);
  }

  // Handling GET request
  Future<void> _handleGetRequest(
      GetDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    emit(APILoading());
    try {
      final response = await http.get(event.url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(
          APISuccess(
            statusCode: response.statusCode,
            data: data.toString(),
            statusReason: response.reasonPhrase,
          ),
        );
      } else {
        emit(APIError('Failed to fetch data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(APIError('Error: $e'));
    }
  }

  // Handling POST request
  Future<void> _handlePostRequest(
      PostDataEvent event, Emitter<HttpRequestFeatureState> emit) async {
    emit(APILoading());
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
            statusCode: response.statusCode,
            data: data.toString(),
            statusReason: response.reasonPhrase,
          ),
        );
      } else {
        emit(APIError('Failed to post data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(APIError('Error: $e'));
    }
  }
}

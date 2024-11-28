// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:hello/hello_method_channel.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_event.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_state.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_bloc.dart';

class MockMethodChannelHello extends Mock implements MethodChannelHello {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late HttpRequestFeatureBloc httpRequestFeatureBloc;
  late MockMethodChannelHello mockMethodChannelHello;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockMethodChannelHello = MockMethodChannelHello();
    mockHttpClient = MockHttpClient();
    httpRequestFeatureBloc = HttpRequestFeatureBloc(
      internetConnectionChannel: mockMethodChannelHello,
      client: mockHttpClient,
    );
    registerFallbackValue(
      Uri.parse('https://example.com'),
    );
  });

  tearDown(() {
    httpRequestFeatureBloc.close();
  });

  group('HttpRequestFeatureBloc', () {
    blocTest<HttpRequestFeatureBloc, HttpRequestFeatureState>(
      'emits [APIReady] when SetAuthDataEvent is added',
      build: () => httpRequestFeatureBloc,
      act: (bloc) => bloc.add(
        SetAuthDataEvent(userName: 'testUser', password: 'testPass'),
      ),
      expect: () => [
        APIReady(
          headers: null,
          userName: 'testUser',
          password: 'testPass',
          queryParams: null,
          body: null,
        ),
      ],
    );

    blocTest<HttpRequestFeatureBloc, HttpRequestFeatureState>(
      'emits [APILoading, APIError] when GetDataEvent is added and network is unavailable',
      setUp: () {
        when(
          () => mockMethodChannelHello.checkNetworkConnectionStatus(),
        ).thenAnswer((_) async => false);
      },
      build: () => httpRequestFeatureBloc,
      act: (bloc) => bloc.add(
        GetDataEvent(
          Uri.parse('https://example.com'),
        ),
      ),
      expect: () => [
        APILoading(
          headers: null,
          userName: null,
          password: null,
          queryParams: null,
          body: null,
        ),
        APIError(
          headers: null,
          password: null,
          userName: null,
          message: 'Please, try your internet connection',
          queryParams: null,
          body: null,
        ),
      ],
    );

    blocTest<HttpRequestFeatureBloc, HttpRequestFeatureState>(
      'emits APIError state then Request is succeed',
      setUp: () {
        when(() => mockMethodChannelHello.checkNetworkConnectionStatus())
            .thenAnswer((_) async => true);
        when(
          () => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response('{"key": "value"}', 200, reasonPhrase: 'OK'),
        );
      },
      build: () => httpRequestFeatureBloc,
      act: (bloc) => bloc.add(
        GetDataEvent(
          Uri.parse('https://example.com'),
        ),
      ),
      expect: () => [
        APILoading(
          headers: null,
          userName: null,
          password: null,
          queryParams: null,
          body: null,
        ),
        APISuccess(
          headers: null,
          statusCode: 200,
          data: 'key : value',
          statusReason: 'OK',
          password: null,
          userName: null,
          queryParams: null,
          body: null,
        ),
      ],
    );

    blocTest<HttpRequestFeatureBloc, HttpRequestFeatureState>(
      'emits APIError state then Request is failed',
      setUp: () {
        when(
          () => mockMethodChannelHello.checkNetworkConnectionStatus(),
        ).thenAnswer((_) async => true);
        when(
          () => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
      },
      build: () => httpRequestFeatureBloc,
      act: (bloc) => bloc.add(
        GetDataEvent(
          Uri.parse('https://example.com'),
        ),
      ),
      expect: () => [
        APILoading(
          headers: null,
          userName: null,
          password: null,
          queryParams: null,
          body: null,
        ),
        APIError(
          headers: null,
          message: 'Failed to fetch data: 404',
          password: null,
          userName: null,
          queryParams: null,
          body: null,
        ),
      ],
    );
  });
}

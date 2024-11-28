import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:new_flutter_template/src/share/enum/request_type_enum.dart';

part 'http_request_model.freezed.dart';

@freezed
class HttpRequestModel with _$HttpRequestModel {
  const factory HttpRequestModel({
    required RequestTypeEnum type,
    required String url,
  }) = _HttpRequestModel;
}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HttpRequestModel {
  RequestTypeEnum get type => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HttpRequestModelCopyWith<HttpRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HttpRequestModelCopyWith<$Res> {
  factory $HttpRequestModelCopyWith(
          HttpRequestModel value, $Res Function(HttpRequestModel) then) =
      _$HttpRequestModelCopyWithImpl<$Res, HttpRequestModel>;
  @useResult
  $Res call({RequestTypeEnum type, String url});
}

/// @nodoc
class _$HttpRequestModelCopyWithImpl<$Res, $Val extends HttpRequestModel>
    implements $HttpRequestModelCopyWith<$Res> {
  _$HttpRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RequestTypeEnum,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HttpRequestModelImplCopyWith<$Res>
    implements $HttpRequestModelCopyWith<$Res> {
  factory _$$HttpRequestModelImplCopyWith(_$HttpRequestModelImpl value,
          $Res Function(_$HttpRequestModelImpl) then) =
      __$$HttpRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RequestTypeEnum type, String url});
}

/// @nodoc
class __$$HttpRequestModelImplCopyWithImpl<$Res>
    extends _$HttpRequestModelCopyWithImpl<$Res, _$HttpRequestModelImpl>
    implements _$$HttpRequestModelImplCopyWith<$Res> {
  __$$HttpRequestModelImplCopyWithImpl(_$HttpRequestModelImpl _value,
      $Res Function(_$HttpRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? url = null,
  }) {
    return _then(_$HttpRequestModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RequestTypeEnum,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HttpRequestModelImpl implements _HttpRequestModel {
  const _$HttpRequestModelImpl({required this.type, required this.url});

  @override
  final RequestTypeEnum type;
  @override
  final String url;

  @override
  String toString() {
    return 'HttpRequestModel(type: $type, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpRequestModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpRequestModelImplCopyWith<_$HttpRequestModelImpl> get copyWith =>
      __$$HttpRequestModelImplCopyWithImpl<_$HttpRequestModelImpl>(
          this, _$identity);
}

abstract class _HttpRequestModel implements HttpRequestModel {
  const factory _HttpRequestModel(
      {required final RequestTypeEnum type,
      required final String url}) = _$HttpRequestModelImpl;

  @override
  RequestTypeEnum get type;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$HttpRequestModelImplCopyWith<_$HttpRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

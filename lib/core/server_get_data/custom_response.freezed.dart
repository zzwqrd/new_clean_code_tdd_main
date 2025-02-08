// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CustomResponse {
  int get statusCode => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  dynamic get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CustomResponseCopyWith<CustomResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomResponseCopyWith<$Res> {
  factory $CustomResponseCopyWith(
          CustomResponse value, $Res Function(CustomResponse) then) =
      _$CustomResponseCopyWithImpl<$Res, CustomResponse>;
  @useResult
  $Res call({int statusCode, String message, dynamic data});
}

/// @nodoc
class _$CustomResponseCopyWithImpl<$Res, $Val extends CustomResponse>
    implements $CustomResponseCopyWith<$Res> {
  _$CustomResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomResponseImplCopyWith<$Res>
    implements $CustomResponseCopyWith<$Res> {
  factory _$$CustomResponseImplCopyWith(_$CustomResponseImpl value,
          $Res Function(_$CustomResponseImpl) then) =
      __$$CustomResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int statusCode, String message, dynamic data});
}

/// @nodoc
class __$$CustomResponseImplCopyWithImpl<$Res>
    extends _$CustomResponseCopyWithImpl<$Res, _$CustomResponseImpl>
    implements _$$CustomResponseImplCopyWith<$Res> {
  __$$CustomResponseImplCopyWithImpl(
      _$CustomResponseImpl _value, $Res Function(_$CustomResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_$CustomResponseImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$CustomResponseImpl implements _CustomResponse {
  const _$CustomResponseImpl(
      {required this.statusCode, required this.message, this.data});

  @override
  final int statusCode;
  @override
  final String message;
  @override
  final dynamic data;

  @override
  String toString() {
    return 'CustomResponse(statusCode: $statusCode, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomResponseImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message,
      const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomResponseImplCopyWith<_$CustomResponseImpl> get copyWith =>
      __$$CustomResponseImplCopyWithImpl<_$CustomResponseImpl>(
          this, _$identity);
}

abstract class _CustomResponse implements CustomResponse {
  const factory _CustomResponse(
      {required final int statusCode,
      required final String message,
      final dynamic data}) = _$CustomResponseImpl;

  @override
  int get statusCode;
  @override
  String get message;
  @override
  dynamic get data;
  @override
  @JsonKey(ignore: true)
  _$$CustomResponseImplCopyWith<_$CustomResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

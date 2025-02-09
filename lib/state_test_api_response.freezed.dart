// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state_test_api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DataState {
  Status get status => throw _privateConstructorUsedError;
  dynamic? get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataStateCopyWith<DataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataStateCopyWith<$Res> {
  factory $DataStateCopyWith(DataState value, $Res Function(DataState) then) =
      _$DataStateCopyWithImpl<$Res, DataState>;
  @useResult
  $Res call({Status status, dynamic? data, String? error});
}

/// @nodoc
class _$DataStateCopyWithImpl<$Res, $Val extends DataState>
    implements $DataStateCopyWith<$Res> {
  _$DataStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataStateImplCopyWith<$Res>
    implements $DataStateCopyWith<$Res> {
  factory _$$DataStateImplCopyWith(
          _$DataStateImpl value, $Res Function(_$DataStateImpl) then) =
      __$$DataStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Status status, dynamic? data, String? error});
}

/// @nodoc
class __$$DataStateImplCopyWithImpl<$Res>
    extends _$DataStateCopyWithImpl<$Res, _$DataStateImpl>
    implements _$$DataStateImplCopyWith<$Res> {
  __$$DataStateImplCopyWithImpl(
      _$DataStateImpl _value, $Res Function(_$DataStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_$DataStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DataStateImpl implements _DataState {
  const _$DataStateImpl({this.status = Status.empty, this.data, this.error});

  @override
  @JsonKey()
  final Status status;
  @override
  final dynamic? data;
  @override
  final String? error;

  @override
  String toString() {
    return 'DataState(status: $status, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, status, const DeepCollectionEquality().hash(data), error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataStateImplCopyWith<_$DataStateImpl> get copyWith =>
      __$$DataStateImplCopyWithImpl<_$DataStateImpl>(this, _$identity);
}

abstract class _DataState implements DataState {
  const factory _DataState(
      {final Status status,
      final dynamic? data,
      final String? error}) = _$DataStateImpl;

  @override
  Status get status;
  @override
  dynamic? get data;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$DataStateImplCopyWith<_$DataStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

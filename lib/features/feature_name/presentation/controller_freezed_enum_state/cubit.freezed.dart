// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyState {
  Status get status => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  dynamic get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MyStateCopyWith<MyState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyStateCopyWith<$Res> {
  factory $MyStateCopyWith(MyState value, $Res Function(MyState) then) =
      _$MyStateCopyWithImpl<$Res, MyState>;
  @useResult
  $Res call({Status status, String? error, dynamic data});
}

/// @nodoc
class _$MyStateCopyWithImpl<$Res, $Val extends MyState>
    implements $MyStateCopyWith<$Res> {
  _$MyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? error = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyStateImplCopyWith<$Res> implements $MyStateCopyWith<$Res> {
  factory _$$MyStateImplCopyWith(
          _$MyStateImpl value, $Res Function(_$MyStateImpl) then) =
      __$$MyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Status status, String? error, dynamic data});
}

/// @nodoc
class __$$MyStateImplCopyWithImpl<$Res>
    extends _$MyStateCopyWithImpl<$Res, _$MyStateImpl>
    implements _$$MyStateImplCopyWith<$Res> {
  __$$MyStateImplCopyWithImpl(
      _$MyStateImpl _value, $Res Function(_$MyStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? error = freezed,
    Object? data = freezed,
  }) {
    return _then(_$MyStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$MyStateImpl implements _MyState {
  const _$MyStateImpl({required this.status, this.error, this.data});

  @override
  final Status status;
  @override
  final String? error;
  @override
  final dynamic data;

  @override
  String toString() {
    return 'MyState(status: $status, error: $error, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, status, error, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MyStateImplCopyWith<_$MyStateImpl> get copyWith =>
      __$$MyStateImplCopyWithImpl<_$MyStateImpl>(this, _$identity);
}

abstract class _MyState implements MyState {
  const factory _MyState(
      {required final Status status,
      final String? error,
      final dynamic data}) = _$MyStateImpl;

  @override
  Status get status;
  @override
  String? get error;
  @override
  dynamic get data;
  @override
  @JsonKey(ignore: true)
  _$$MyStateImplCopyWith<_$MyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

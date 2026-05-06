// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logged_in_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoggedInUser _$LoggedInUserFromJson(Map<String, dynamic> json) {
  return _LoggedInUser.fromJson(json);
}

/// @nodoc
mixin _$LoggedInUser {
  String get name => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name', defaultValue: '')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'message', defaultValue: '')
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_page', defaultValue: '')
  String? get homePage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name', defaultValue: '')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'api_key', defaultValue: '')
  String get apiKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'api_secret', defaultValue: '')
  String get apiSecret => throw _privateConstructorUsedError;
  @JsonKey(name: 'email', defaultValue: '')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: '')
  String? get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_profile_name', defaultValue: '')
  String? get roleProfileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_type')
  String? get userType => throw _privateConstructorUsedError;
  @JsonKey(name: 'gender')
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'depo_name')
  String? get depoName => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_name')
  String? get plantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'mobile_no')
  String? get mobileNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'otp_verified')
  bool? get isOtpVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_status')
  RoleStatus? get roleStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoggedInUserCopyWith<LoggedInUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoggedInUserCopyWith<$Res> {
  factory $LoggedInUserCopyWith(
          LoggedInUser value, $Res Function(LoggedInUser) then) =
      _$LoggedInUserCopyWithImpl<$Res, LoggedInUser>;
  @useResult
  $Res call(
      {String name,
      String? username,
      @JsonKey(name: 'first_name', defaultValue: '') String? firstName,
      @JsonKey(name: 'message', defaultValue: '') String? message,
      @JsonKey(name: 'home_page', defaultValue: '') String? homePage,
      @JsonKey(name: 'last_name', defaultValue: '') String? lastName,
      @JsonKey(name: 'api_key', defaultValue: '') String apiKey,
      @JsonKey(name: 'api_secret', defaultValue: '') String apiSecret,
      @JsonKey(name: 'email', defaultValue: '') String? email,
      @JsonKey(defaultValue: '') String? password,
      @JsonKey(name: 'role_profile_name', defaultValue: '')
      String? roleProfileName,
      @JsonKey(name: 'user_type') String? userType,
      @JsonKey(name: 'gender') String? gender,
      @JsonKey(name: 'birth_date') String? birthDate,
      @JsonKey(name: 'depo_name') String? depoName,
      @JsonKey(name: 'plant_name') String? plantName,
      @JsonKey(name: 'full_name') String? fullName,
      String? phone,
      String? location,
      String? bio,
      @JsonKey(name: 'mobile_no') String? mobileNo,
      @JsonKey(name: 'otp_verified') bool? isOtpVerified,
      @JsonKey(name: 'role_status') RoleStatus? roleStatus});

  $RoleStatusCopyWith<$Res>? get roleStatus;
}

/// @nodoc
class _$LoggedInUserCopyWithImpl<$Res, $Val extends LoggedInUser>
    implements $LoggedInUserCopyWith<$Res> {
  _$LoggedInUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? username = freezed,
    Object? firstName = freezed,
    Object? message = freezed,
    Object? homePage = freezed,
    Object? lastName = freezed,
    Object? apiKey = null,
    Object? apiSecret = null,
    Object? email = freezed,
    Object? password = freezed,
    Object? roleProfileName = freezed,
    Object? userType = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? depoName = freezed,
    Object? plantName = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? location = freezed,
    Object? bio = freezed,
    Object? mobileNo = freezed,
    Object? isOtpVerified = freezed,
    Object? roleStatus = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      homePage: freezed == homePage
          ? _value.homePage
          : homePage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      apiSecret: null == apiSecret
          ? _value.apiSecret
          : apiSecret // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      roleProfileName: freezed == roleProfileName
          ? _value.roleProfileName
          : roleProfileName // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: freezed == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      depoName: freezed == depoName
          ? _value.depoName
          : depoName // ignore: cast_nullable_to_non_nullable
              as String?,
      plantName: freezed == plantName
          ? _value.plantName
          : plantName // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNo: freezed == mobileNo
          ? _value.mobileNo
          : mobileNo // ignore: cast_nullable_to_non_nullable
              as String?,
      isOtpVerified: freezed == isOtpVerified
          ? _value.isOtpVerified
          : isOtpVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      roleStatus: freezed == roleStatus
          ? _value.roleStatus
          : roleStatus // ignore: cast_nullable_to_non_nullable
              as RoleStatus?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoleStatusCopyWith<$Res>? get roleStatus {
    if (_value.roleStatus == null) {
      return null;
    }

    return $RoleStatusCopyWith<$Res>(_value.roleStatus!, (value) {
      return _then(_value.copyWith(roleStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoggedInUserImplCopyWith<$Res>
    implements $LoggedInUserCopyWith<$Res> {
  factory _$$LoggedInUserImplCopyWith(
          _$LoggedInUserImpl value, $Res Function(_$LoggedInUserImpl) then) =
      __$$LoggedInUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? username,
      @JsonKey(name: 'first_name', defaultValue: '') String? firstName,
      @JsonKey(name: 'message', defaultValue: '') String? message,
      @JsonKey(name: 'home_page', defaultValue: '') String? homePage,
      @JsonKey(name: 'last_name', defaultValue: '') String? lastName,
      @JsonKey(name: 'api_key', defaultValue: '') String apiKey,
      @JsonKey(name: 'api_secret', defaultValue: '') String apiSecret,
      @JsonKey(name: 'email', defaultValue: '') String? email,
      @JsonKey(defaultValue: '') String? password,
      @JsonKey(name: 'role_profile_name', defaultValue: '')
      String? roleProfileName,
      @JsonKey(name: 'user_type') String? userType,
      @JsonKey(name: 'gender') String? gender,
      @JsonKey(name: 'birth_date') String? birthDate,
      @JsonKey(name: 'depo_name') String? depoName,
      @JsonKey(name: 'plant_name') String? plantName,
      @JsonKey(name: 'full_name') String? fullName,
      String? phone,
      String? location,
      String? bio,
      @JsonKey(name: 'mobile_no') String? mobileNo,
      @JsonKey(name: 'otp_verified') bool? isOtpVerified,
      @JsonKey(name: 'role_status') RoleStatus? roleStatus});

  @override
  $RoleStatusCopyWith<$Res>? get roleStatus;
}

/// @nodoc
class __$$LoggedInUserImplCopyWithImpl<$Res>
    extends _$LoggedInUserCopyWithImpl<$Res, _$LoggedInUserImpl>
    implements _$$LoggedInUserImplCopyWith<$Res> {
  __$$LoggedInUserImplCopyWithImpl(
      _$LoggedInUserImpl _value, $Res Function(_$LoggedInUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? username = freezed,
    Object? firstName = freezed,
    Object? message = freezed,
    Object? homePage = freezed,
    Object? lastName = freezed,
    Object? apiKey = null,
    Object? apiSecret = null,
    Object? email = freezed,
    Object? password = freezed,
    Object? roleProfileName = freezed,
    Object? userType = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? depoName = freezed,
    Object? plantName = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? location = freezed,
    Object? bio = freezed,
    Object? mobileNo = freezed,
    Object? isOtpVerified = freezed,
    Object? roleStatus = freezed,
  }) {
    return _then(_$LoggedInUserImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      homePage: freezed == homePage
          ? _value.homePage
          : homePage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      apiSecret: null == apiSecret
          ? _value.apiSecret
          : apiSecret // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      roleProfileName: freezed == roleProfileName
          ? _value.roleProfileName
          : roleProfileName // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: freezed == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      depoName: freezed == depoName
          ? _value.depoName
          : depoName // ignore: cast_nullable_to_non_nullable
              as String?,
      plantName: freezed == plantName
          ? _value.plantName
          : plantName // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNo: freezed == mobileNo
          ? _value.mobileNo
          : mobileNo // ignore: cast_nullable_to_non_nullable
              as String?,
      isOtpVerified: freezed == isOtpVerified
          ? _value.isOtpVerified
          : isOtpVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      roleStatus: freezed == roleStatus
          ? _value.roleStatus
          : roleStatus // ignore: cast_nullable_to_non_nullable
              as RoleStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoggedInUserImpl extends _LoggedInUser {
  const _$LoggedInUserImpl(
      {required this.name,
      this.username,
      @JsonKey(name: 'first_name', defaultValue: '') this.firstName,
      @JsonKey(name: 'message', defaultValue: '') this.message,
      @JsonKey(name: 'home_page', defaultValue: '') this.homePage,
      @JsonKey(name: 'last_name', defaultValue: '') this.lastName,
      @JsonKey(name: 'api_key', defaultValue: '') required this.apiKey,
      @JsonKey(name: 'api_secret', defaultValue: '') required this.apiSecret,
      @JsonKey(name: 'email', defaultValue: '') this.email,
      @JsonKey(defaultValue: '') this.password,
      @JsonKey(name: 'role_profile_name', defaultValue: '')
      this.roleProfileName,
      @JsonKey(name: 'user_type') this.userType,
      @JsonKey(name: 'gender') this.gender,
      @JsonKey(name: 'birth_date') this.birthDate,
      @JsonKey(name: 'depo_name') this.depoName,
      @JsonKey(name: 'plant_name') this.plantName,
      @JsonKey(name: 'full_name') this.fullName,
      this.phone,
      this.location,
      this.bio,
      @JsonKey(name: 'mobile_no') this.mobileNo,
      @JsonKey(name: 'otp_verified') this.isOtpVerified,
      @JsonKey(name: 'role_status') this.roleStatus})
      : super._();

  factory _$LoggedInUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoggedInUserImplFromJson(json);

  @override
  final String name;
  @override
  final String? username;
  @override
  @JsonKey(name: 'first_name', defaultValue: '')
  final String? firstName;
  @override
  @JsonKey(name: 'message', defaultValue: '')
  final String? message;
  @override
  @JsonKey(name: 'home_page', defaultValue: '')
  final String? homePage;
  @override
  @JsonKey(name: 'last_name', defaultValue: '')
  final String? lastName;
  @override
  @JsonKey(name: 'api_key', defaultValue: '')
  final String apiKey;
  @override
  @JsonKey(name: 'api_secret', defaultValue: '')
  final String apiSecret;
  @override
  @JsonKey(name: 'email', defaultValue: '')
  final String? email;
  @override
  @JsonKey(defaultValue: '')
  final String? password;
  @override
  @JsonKey(name: 'role_profile_name', defaultValue: '')
  final String? roleProfileName;
  @override
  @JsonKey(name: 'user_type')
  final String? userType;
  @override
  @JsonKey(name: 'gender')
  final String? gender;
  @override
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @override
  @JsonKey(name: 'depo_name')
  final String? depoName;
  @override
  @JsonKey(name: 'plant_name')
  final String? plantName;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  final String? phone;
  @override
  final String? location;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'mobile_no')
  final String? mobileNo;
  @override
  @JsonKey(name: 'otp_verified')
  final bool? isOtpVerified;
  @override
  @JsonKey(name: 'role_status')
  final RoleStatus? roleStatus;

  @override
  String toString() {
    return 'LoggedInUser(name: $name, username: $username, firstName: $firstName, message: $message, homePage: $homePage, lastName: $lastName, apiKey: $apiKey, apiSecret: $apiSecret, email: $email, password: $password, roleProfileName: $roleProfileName, userType: $userType, gender: $gender, birthDate: $birthDate, depoName: $depoName, plantName: $plantName, fullName: $fullName, phone: $phone, location: $location, bio: $bio, mobileNo: $mobileNo, isOtpVerified: $isOtpVerified, roleStatus: $roleStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoggedInUserImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.homePage, homePage) ||
                other.homePage == homePage) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.apiSecret, apiSecret) ||
                other.apiSecret == apiSecret) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.roleProfileName, roleProfileName) ||
                other.roleProfileName == roleProfileName) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.depoName, depoName) ||
                other.depoName == depoName) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.mobileNo, mobileNo) ||
                other.mobileNo == mobileNo) &&
            (identical(other.isOtpVerified, isOtpVerified) ||
                other.isOtpVerified == isOtpVerified) &&
            (identical(other.roleStatus, roleStatus) ||
                other.roleStatus == roleStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        username,
        firstName,
        message,
        homePage,
        lastName,
        apiKey,
        apiSecret,
        email,
        password,
        roleProfileName,
        userType,
        gender,
        birthDate,
        depoName,
        plantName,
        fullName,
        phone,
        location,
        bio,
        mobileNo,
        isOtpVerified,
        roleStatus
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoggedInUserImplCopyWith<_$LoggedInUserImpl> get copyWith =>
      __$$LoggedInUserImplCopyWithImpl<_$LoggedInUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoggedInUserImplToJson(
      this,
    );
  }
}

abstract class _LoggedInUser extends LoggedInUser {
  const factory _LoggedInUser(
      {required final String name,
      final String? username,
      @JsonKey(name: 'first_name', defaultValue: '') final String? firstName,
      @JsonKey(name: 'message', defaultValue: '') final String? message,
      @JsonKey(name: 'home_page', defaultValue: '') final String? homePage,
      @JsonKey(name: 'last_name', defaultValue: '') final String? lastName,
      @JsonKey(name: 'api_key', defaultValue: '') required final String apiKey,
      @JsonKey(name: 'api_secret', defaultValue: '')
      required final String apiSecret,
      @JsonKey(name: 'email', defaultValue: '') final String? email,
      @JsonKey(defaultValue: '') final String? password,
      @JsonKey(name: 'role_profile_name', defaultValue: '')
      final String? roleProfileName,
      @JsonKey(name: 'user_type') final String? userType,
      @JsonKey(name: 'gender') final String? gender,
      @JsonKey(name: 'birth_date') final String? birthDate,
      @JsonKey(name: 'depo_name') final String? depoName,
      @JsonKey(name: 'plant_name') final String? plantName,
      @JsonKey(name: 'full_name') final String? fullName,
      final String? phone,
      final String? location,
      final String? bio,
      @JsonKey(name: 'mobile_no') final String? mobileNo,
      @JsonKey(name: 'otp_verified') final bool? isOtpVerified,
      @JsonKey(name: 'role_status')
      final RoleStatus? roleStatus}) = _$LoggedInUserImpl;
  const _LoggedInUser._() : super._();

  factory _LoggedInUser.fromJson(Map<String, dynamic> json) =
      _$LoggedInUserImpl.fromJson;

  @override
  String get name;
  @override
  String? get username;
  @override
  @JsonKey(name: 'first_name', defaultValue: '')
  String? get firstName;
  @override
  @JsonKey(name: 'message', defaultValue: '')
  String? get message;
  @override
  @JsonKey(name: 'home_page', defaultValue: '')
  String? get homePage;
  @override
  @JsonKey(name: 'last_name', defaultValue: '')
  String? get lastName;
  @override
  @JsonKey(name: 'api_key', defaultValue: '')
  String get apiKey;
  @override
  @JsonKey(name: 'api_secret', defaultValue: '')
  String get apiSecret;
  @override
  @JsonKey(name: 'email', defaultValue: '')
  String? get email;
  @override
  @JsonKey(defaultValue: '')
  String? get password;
  @override
  @JsonKey(name: 'role_profile_name', defaultValue: '')
  String? get roleProfileName;
  @override
  @JsonKey(name: 'user_type')
  String? get userType;
  @override
  @JsonKey(name: 'gender')
  String? get gender;
  @override
  @JsonKey(name: 'birth_date')
  String? get birthDate;
  @override
  @JsonKey(name: 'depo_name')
  String? get depoName;
  @override
  @JsonKey(name: 'plant_name')
  String? get plantName;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  String? get phone;
  @override
  String? get location;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'mobile_no')
  String? get mobileNo;
  @override
  @JsonKey(name: 'otp_verified')
  bool? get isOtpVerified;
  @override
  @JsonKey(name: 'role_status')
  RoleStatus? get roleStatus;
  @override
  @JsonKey(ignore: true)
  _$$LoggedInUserImplCopyWith<_$LoggedInUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoleStatus _$RoleStatusFromJson(Map<String, dynamic> json) {
  return _RoleStatus.fromJson(json);
}

/// @nodoc
mixin _$RoleStatus {
  @JsonKey(name: 'Show Logistic Booking In Mobile App')
  int? get showLogistic => throw _privateConstructorUsedError;
  @JsonKey(name: 'Show Loading In Mobile App')
  int? get showLoading => throw _privateConstructorUsedError;
  @JsonKey(name: 'Show Order Delivery In Mobile App')
  int? get showDispatch => throw _privateConstructorUsedError;
  @JsonKey(name: 'Show Crate Inward In Mobile App')
  int? get showInward => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoleStatusCopyWith<RoleStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleStatusCopyWith<$Res> {
  factory $RoleStatusCopyWith(
          RoleStatus value, $Res Function(RoleStatus) then) =
      _$RoleStatusCopyWithImpl<$Res, RoleStatus>;
  @useResult
  $Res call(
      {@JsonKey(name: 'Show Logistic Booking In Mobile App') int? showLogistic,
      @JsonKey(name: 'Show Loading In Mobile App') int? showLoading,
      @JsonKey(name: 'Show Order Delivery In Mobile App') int? showDispatch,
      @JsonKey(name: 'Show Crate Inward In Mobile App') int? showInward});
}

/// @nodoc
class _$RoleStatusCopyWithImpl<$Res, $Val extends RoleStatus>
    implements $RoleStatusCopyWith<$Res> {
  _$RoleStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showLogistic = freezed,
    Object? showLoading = freezed,
    Object? showDispatch = freezed,
    Object? showInward = freezed,
  }) {
    return _then(_value.copyWith(
      showLogistic: freezed == showLogistic
          ? _value.showLogistic
          : showLogistic // ignore: cast_nullable_to_non_nullable
              as int?,
      showLoading: freezed == showLoading
          ? _value.showLoading
          : showLoading // ignore: cast_nullable_to_non_nullable
              as int?,
      showDispatch: freezed == showDispatch
          ? _value.showDispatch
          : showDispatch // ignore: cast_nullable_to_non_nullable
              as int?,
      showInward: freezed == showInward
          ? _value.showInward
          : showInward // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleStatusImplCopyWith<$Res>
    implements $RoleStatusCopyWith<$Res> {
  factory _$$RoleStatusImplCopyWith(
          _$RoleStatusImpl value, $Res Function(_$RoleStatusImpl) then) =
      __$$RoleStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Show Logistic Booking In Mobile App') int? showLogistic,
      @JsonKey(name: 'Show Loading In Mobile App') int? showLoading,
      @JsonKey(name: 'Show Order Delivery In Mobile App') int? showDispatch,
      @JsonKey(name: 'Show Crate Inward In Mobile App') int? showInward});
}

/// @nodoc
class __$$RoleStatusImplCopyWithImpl<$Res>
    extends _$RoleStatusCopyWithImpl<$Res, _$RoleStatusImpl>
    implements _$$RoleStatusImplCopyWith<$Res> {
  __$$RoleStatusImplCopyWithImpl(
      _$RoleStatusImpl _value, $Res Function(_$RoleStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showLogistic = freezed,
    Object? showLoading = freezed,
    Object? showDispatch = freezed,
    Object? showInward = freezed,
  }) {
    return _then(_$RoleStatusImpl(
      showLogistic: freezed == showLogistic
          ? _value.showLogistic
          : showLogistic // ignore: cast_nullable_to_non_nullable
              as int?,
      showLoading: freezed == showLoading
          ? _value.showLoading
          : showLoading // ignore: cast_nullable_to_non_nullable
              as int?,
      showDispatch: freezed == showDispatch
          ? _value.showDispatch
          : showDispatch // ignore: cast_nullable_to_non_nullable
              as int?,
      showInward: freezed == showInward
          ? _value.showInward
          : showInward // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoleStatusImpl extends _RoleStatus {
  const _$RoleStatusImpl(
      {@JsonKey(name: 'Show Logistic Booking In Mobile App') this.showLogistic,
      @JsonKey(name: 'Show Loading In Mobile App') this.showLoading,
      @JsonKey(name: 'Show Order Delivery In Mobile App') this.showDispatch,
      @JsonKey(name: 'Show Crate Inward In Mobile App') this.showInward})
      : super._();

  factory _$RoleStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleStatusImplFromJson(json);

  @override
  @JsonKey(name: 'Show Logistic Booking In Mobile App')
  final int? showLogistic;
  @override
  @JsonKey(name: 'Show Loading In Mobile App')
  final int? showLoading;
  @override
  @JsonKey(name: 'Show Order Delivery In Mobile App')
  final int? showDispatch;
  @override
  @JsonKey(name: 'Show Crate Inward In Mobile App')
  final int? showInward;

  @override
  String toString() {
    return 'RoleStatus(showLogistic: $showLogistic, showLoading: $showLoading, showDispatch: $showDispatch, showInward: $showInward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleStatusImpl &&
            (identical(other.showLogistic, showLogistic) ||
                other.showLogistic == showLogistic) &&
            (identical(other.showLoading, showLoading) ||
                other.showLoading == showLoading) &&
            (identical(other.showDispatch, showDispatch) ||
                other.showDispatch == showDispatch) &&
            (identical(other.showInward, showInward) ||
                other.showInward == showInward));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, showLogistic, showLoading, showDispatch, showInward);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleStatusImplCopyWith<_$RoleStatusImpl> get copyWith =>
      __$$RoleStatusImplCopyWithImpl<_$RoleStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleStatusImplToJson(
      this,
    );
  }
}

abstract class _RoleStatus extends RoleStatus {
  const factory _RoleStatus(
      {@JsonKey(name: 'Show Logistic Booking In Mobile App')
      final int? showLogistic,
      @JsonKey(name: 'Show Loading In Mobile App') final int? showLoading,
      @JsonKey(name: 'Show Order Delivery In Mobile App')
      final int? showDispatch,
      @JsonKey(name: 'Show Crate Inward In Mobile App')
      final int? showInward}) = _$RoleStatusImpl;
  const _RoleStatus._() : super._();

  factory _RoleStatus.fromJson(Map<String, dynamic> json) =
      _$RoleStatusImpl.fromJson;

  @override
  @JsonKey(name: 'Show Logistic Booking In Mobile App')
  int? get showLogistic;
  @override
  @JsonKey(name: 'Show Loading In Mobile App')
  int? get showLoading;
  @override
  @JsonKey(name: 'Show Order Delivery In Mobile App')
  int? get showDispatch;
  @override
  @JsonKey(name: 'Show Crate Inward In Mobile App')
  int? get showInward;
  @override
  @JsonKey(ignore: true)
  _$$RoleStatusImplCopyWith<_$RoleStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

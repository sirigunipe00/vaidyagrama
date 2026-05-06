// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_in_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoggedInUserImpl _$$LoggedInUserImplFromJson(Map<String, dynamic> json) =>
    _$LoggedInUserImpl(
      name: json['name'] as String,
      username: json['username'] as String?,
      firstName: json['first_name'] as String? ?? '',
      message: json['message'] as String? ?? '',
      homePage: json['home_page'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      apiKey: json['api_key'] as String? ?? '',
      apiSecret: json['api_secret'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      roleProfileName: json['role_profile_name'] as String? ?? '',
      userType: json['user_type'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] as String?,
      depoName: json['depo_name'] as String?,
      plantName: json['plant_name'] as String?,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      mobileNo: json['mobile_no'] as String?,
      isOtpVerified: json['otp_verified'] as bool?,
      roleStatus: json['role_status'] == null
          ? null
          : RoleStatus.fromJson(json['role_status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoggedInUserImplToJson(_$LoggedInUserImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'first_name': instance.firstName,
      'message': instance.message,
      'home_page': instance.homePage,
      'last_name': instance.lastName,
      'api_key': instance.apiKey,
      'api_secret': instance.apiSecret,
      'email': instance.email,
      'password': instance.password,
      'role_profile_name': instance.roleProfileName,
      'user_type': instance.userType,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'depo_name': instance.depoName,
      'plant_name': instance.plantName,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'location': instance.location,
      'bio': instance.bio,
      'mobile_no': instance.mobileNo,
      'otp_verified': instance.isOtpVerified,
      'role_status': instance.roleStatus,
    };

_$RoleStatusImpl _$$RoleStatusImplFromJson(Map<String, dynamic> json) =>
    _$RoleStatusImpl(
      showLogistic:
          (json['Show Logistic Booking In Mobile App'] as num?)?.toInt(),
      showLoading: (json['Show Loading In Mobile App'] as num?)?.toInt(),
      showDispatch:
          (json['Show Order Delivery In Mobile App'] as num?)?.toInt(),
      showInward: (json['Show Crate Inward In Mobile App'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RoleStatusImplToJson(_$RoleStatusImpl instance) =>
    <String, dynamic>{
      'Show Logistic Booking In Mobile App': instance.showLogistic,
      'Show Loading In Mobile App': instance.showLoading,
      'Show Order Delivery In Mobile App': instance.showDispatch,
      'Show Crate Inward In Mobile App': instance.showInward,
    };

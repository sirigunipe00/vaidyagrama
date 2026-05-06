import 'package:freezed_annotation/freezed_annotation.dart';

part 'logged_in_user.freezed.dart';
part 'logged_in_user.g.dart';

@freezed
class LoggedInUser with _$LoggedInUser {
  const LoggedInUser._();

  const factory LoggedInUser({
    required String name,
    String? username,

    @JsonKey(name: 'first_name', defaultValue: '') String? firstName,
    @JsonKey(name: 'message', defaultValue: '') String? message,
    @JsonKey(name: 'home_page', defaultValue: '') String? homePage,


    @JsonKey(name: 'last_name', defaultValue: '') String? lastName,
    @JsonKey(name: 'api_key', defaultValue: '') required String apiKey,
    @JsonKey(name: 'api_secret', defaultValue: '') required String apiSecret,
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

    @JsonKey(name: 'role_status') RoleStatus? roleStatus,
  }) = _LoggedInUser;

  factory LoggedInUser.fromJson(Map<String, dynamic> json) =>
      _$LoggedInUserFromJson(json);
}

@freezed
class RoleStatus with _$RoleStatus {
  const RoleStatus._();

  const factory RoleStatus({
    @JsonKey(name: 'Show Logistic Booking In Mobile App') int? showLogistic,
    @JsonKey(name: 'Show Loading In Mobile App') int? showLoading,
    @JsonKey(name: 'Show Order Delivery In Mobile App') int? showDispatch,
    @JsonKey(name: 'Show Crate Inward In Mobile App') int? showInward,

  }) = _RoleStatus;

  factory RoleStatus.fromJson(Map<String, dynamic> json) =>
      _$RoleStatusFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_device_info.freezed.dart';

@freezed
class UserDeviceInfo with _$UserDeviceInfo {
  const factory UserDeviceInfo({
    required String deviceType,
    required String osName,
    required String deviceUniqueId,
    required String installedAppVersion,
    required String latestAppVersion,
    required String pushNotificationDeviceId,
    String? osDetails,
    String? description,
  }) = _UserDeviceInfo;
}
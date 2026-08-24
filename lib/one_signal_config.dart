import 'package:app/core/utils/app_flavor.dart';

class OneSignalConfig {
  static const vaidyagramaAppId = '65171972-805d-470d-b0de-0cfc51158e65';
  static const restApiKey =
      String.fromEnvironment('ONESIGNAL_REST_API_KEY');

  static String appIdFor(FrappeAppMode mode) => switch (mode) {
    FrappeAppMode.vaidyagrama => vaidyagramaAppId,
    FrappeAppMode.saranya => 'YOUR_SARANYA_ONESIGNAL_APP_ID',
  };
}
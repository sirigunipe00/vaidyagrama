

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:vaidyagrama/app/data/app_version.dart';
import 'package:vaidyagrama/core/consts/urls.dart';
import 'package:vaidyagrama/core/logger/app_logger.dart';
import 'package:vaidyagrama/core/model/failure.dart';
import 'package:vaidyagrama/core/network/base_api_repo.dart';
import 'package:vaidyagrama/core/network/request_config.dart';
import 'package:vaidyagrama/core/utils/dartz_utils.dart';

@lazySingleton
class AppRepository extends BaseApiRepository {
  AppRepository(super.client, this.appVersion);

  final AppVersion appVersion;

  Future<Either<Failure, bool>> isAppUpdateAvailable() async {
    final requestConfig = RequestConfig(
      url: Urls.appVersion,
      parser: (p0) => p0,
    );
    final response = await post(requestConfig, includeAuthHeader: false);

    return await response.processAsync((r) async {
      final responseData = r.data!;
      final data = responseData['data'];

      if (data['status'] == 400) {
        return left(Failure(error: data['message']));
      }
      final serverVersion = data['app_version'] ?? '';
      final appVersionStr = await appVersion.getAppVersion();
      $logger..devLog('APPVERSION:$appVersionStr')
      ..devLog('SERVER VERSION:$serverVersion');
     bool updateRequired = isUpdateRequired(appVersionStr, serverVersion);

      if (updateRequired) {
        return right(true);
      } else {
        return right(false);
      }
    });
  }
}
bool isUpdateRequired(String appVersion, String serverVersion) {
  // Handle empty or null server version - no update required if server version is empty
  if (serverVersion.isEmpty || serverVersion == 'null') {
    return false;
  }
  
  // Handle empty app version - update required if app version is empty but server has version
  if (appVersion.isEmpty) {
    return true;
  }
  
  List<int> appParts = appVersion.split('.').map(int.parse).toList();
  List<int> serverParts = serverVersion.split('.').map(int.parse).toList();

  for (int i = 0; i < serverParts.length; i++) {
    int app = (i < appParts.length) ? appParts[i] : 0;
    int server = serverParts[i];

    if (app < server) return true; 
    if (app > server) return false; 
  }
  return false; 
}

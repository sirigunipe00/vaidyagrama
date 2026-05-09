

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:app/app/data/app_version.dart';
import 'package:app/core/consts/urls.dart';
import 'package:app/core/logger/app_logger.dart';
import 'package:app/core/model/failure.dart';
import 'package:app/core/network/base_api_repo.dart';
import 'package:app/core/network/request_config.dart';
import 'package:app/core/utils/dartz_utils.dart';

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

  if (serverVersion.isEmpty || serverVersion == 'null') {
    return false;
  }
  

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

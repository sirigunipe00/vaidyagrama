// import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';
// import 'package:shakti_hormann/app/data/app_version.dart';

// import 'package:shakti_hormann/core/core.dart';

// import 'package:shakti_hormann/app/data/app_repo.dart';

// @LazySingleton(as: AppRepo)
// class AppRepoImpl extends BaseApiRepository implements AppRepo {
//   const AppRepoImpl(super.client, this.appVersion);
  

//   final AppVersion appVersion;
//   // @override
//   // AsyncValueOf<bool> sendOTP(OTPInput inp) async {
//   //   return await executeSafely(() async {
//   //     final config = RequestConfig(
//   //       url: Urls.sendOTP,
//   //       parser: (_) => true,
//   //       reqParams: {
//   //         'otp_code': inp.otp,
//   //         'phone_number': inp.number,
//   //         'otp_type': inp.type.code,
//   //       }
//   //     );
//   //     $logger.devLog(config);
//   //     final response = await post(config);
//   //     return response.process((r) => right(true));
//   //   });
//   // }
 

//   @override
//   Future<Either<Failure, bool>> isAppUpdateAvailable() async {
//     final requestConfig = RequestConfig(
//       url: Urls.appVersion,
//       parser: (p0) => p0,
//     );
//     final response = await post(requestConfig, includeAuthHeader: false);

//     return await response.processAsync((r) async {
//       final responseData = r.data!;
//       final data = responseData['data'];

//       if (data['status'] == 400) {
//         return left(Failure(error: data['message']));
//       }
//       final serverVersion = data['app_version'] ?? '';
//       final appVersionStr = await appVersion.getAppVersion();
//       print('APPVERSION:$appVersionStr');
//       print('SERVER VERSION:$serverVersion');
//       if (appVersionStr.compareTo(serverVersion) < 0) {
//         return right(true);
//       }
//       return right(false);
//     });
//   }
// }

  



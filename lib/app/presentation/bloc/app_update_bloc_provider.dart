
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:vaidyagrama/app/data/app_repo.dart';
import 'package:vaidyagrama/core/core.dart';


typedef AppVersionCubit = NetworkRequestCubit<bool, None>;
typedef AppVersionCubitState = NetworkRequestState<bool>;

@lazySingleton
class AppUpdateBlocprovider {
  AppUpdateBlocprovider(this.repository);

  final AppRepository repository;

  static AppUpdateBlocprovider get() => $sl.get<AppUpdateBlocprovider>();

  AppVersionCubit appversionCubit() => NetworkRequestCubit(
        onRequest: (_, state) => repository.isAppUpdateAvailable());
}

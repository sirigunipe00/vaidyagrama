// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i4;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:package_info_plus/package_info_plus.dart' as _i6;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

import '../../app/data/app_repo.dart' as _i17;
import '../../app/data/app_version.dart' as _i12;
import '../../app/presentation/bloc/app_update_bloc_provider.dart' as _i18;
import '../../features/auth/data/auth_repo.dart' as _i13;
import '../../features/auth/data/auth_repo_impl.dart' as _i14;
import '../../features/auth/presentation/bloc/auth/auth_cubit.dart' as _i16;
import '../../features/auth/presentation/ui/sign_in/sign_in_cubit.dart' as _i15;
import '../core.dart' as _i10;
import '../local_storage/key_vale_storage.dart' as _i11;
import '../network/api_client.dart' as _i9;
import '../network/internet_check.dart' as _i8;
import 'injector.dart' as _i19;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyDependencies = _$ThirdPartyDependencies();
    gh.factory<DateTime>(() => thirdPartyDependencies.defaultDateTime);
    gh.singleton<_i3.Client>(() => thirdPartyDependencies.httpClient);
    gh.singleton<_i4.Connectivity>(() => thirdPartyDependencies.connectivity);
    gh.singleton<_i5.FlutterSecureStorage>(
        () => thirdPartyDependencies.secureStorage);
    await gh.singletonAsync<_i6.PackageInfo>(
      () => thirdPartyDependencies.packageInfo,
      preResolve: true,
    );
    await gh.singletonAsync<_i7.SharedPreferences>(
      () => thirdPartyDependencies.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i8.InternetConnectionChecker>(
        () => _i8.InternetConnectionChecker(gh<_i4.Connectivity>()));
    gh.factory<_i9.ApiClient>(() => _i9.ApiClient(
          gh<_i3.Client>(),
          gh<_i10.InternetConnectionChecker>(),
        ));
    gh.factory<_i11.KeyValueStorage>(() => _i11.KeyValueStorage(
          gh<_i5.FlutterSecureStorage>(),
          gh<_i7.SharedPreferences>(),
        ));
    gh.lazySingleton<_i12.AppVersion>(
        () => _i12.AppVersion(gh<_i6.PackageInfo>()));
    gh.lazySingleton<_i13.AuthRepo>(() => _i14.AuthRepoImpl(
          gh<_i10.ApiClient>(),
          gh<_i10.KeyValueStorage>(),
        ));
    gh.factory<_i15.SignInCubit>(() => _i15.SignInCubit(gh<_i13.AuthRepo>()));
    gh.factory<_i16.AuthCubit>(() => _i16.AuthCubit(gh<_i13.AuthRepo>()));
    gh.lazySingleton<_i17.AppRepository>(() => _i17.AppRepository(
          gh<_i10.ApiClient>(),
          gh<_i12.AppVersion>(),
        ));
    gh.lazySingleton<_i18.AppUpdateBlocprovider>(
        () => _i18.AppUpdateBlocprovider(gh<_i17.AppRepository>()));
    return this;
  }
}

class _$ThirdPartyDependencies extends _i19.ThirdPartyDependencies {}

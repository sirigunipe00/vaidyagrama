import 'dart:async';
import 'dart:isolate';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:app/core/utils/app_flavor.dart';
import 'package:app/firebase/saranya_firebase_options.dart';
import 'package:app/firebase/vaidyagrama_firebase_options.dart';


import 'core/core.dart';

Future<void> bootstrap(AppFlavour config ,void Function() runApp) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown,

  ]);
  await _initInjector();
  await register<AppFlavour>(config);

  // Register Url as Per Mode
  final url = switch (config.mode) {
    FrappeAppMode.vaidyagrama => kDebugMode ? Urls.uAT() : Urls.uAT(),
    FrappeAppMode.saranya => kDebugMode ? Urls.uAT() : Urls.uAT(),

  };
  await register<Urls>(url, instanceName: 'baseUrl');

  // Register FirebaseOptions as Per Mode
  final firebaseOptions = switch (config.mode) {
    FrappeAppMode.vaidyagrama => VaidyagramaFirebaseOptions.currentPlatform,
    FrappeAppMode.saranya => SaranyaFirebaseOptions.currentPlatform,

  };
  await _initFirebase(firebaseOptions);
  _setupErrorHandling(runApp);
}

Future<void> _initInjector() async {
  await configureDependencies(env: Environment.prod);
  await register(AppLogger());
}

Future<void> _initFirebase(FirebaseOptions options) async {
  await Firebase.initializeApp(options: options);
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

void _setupErrorHandling(void Function() runApp) {
  Isolate.current.addErrorListener(
    RawReceivePort((List<dynamic> pair) async {
      try {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last as StackTrace,
        );
      } on Exception catch (e, st) {
        $logger.error('[Running isolate error]', e, st);
      }
    }).sendPort,
  );

  runZonedGuarded<Future<void>>(
    () async {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      runApp();
    },
    FirebaseCrashlytics.instance.recordError,
  );
}
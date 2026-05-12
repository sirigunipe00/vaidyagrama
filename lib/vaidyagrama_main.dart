import 'package:app/core/utils/app_flavor.dart';
import 'package:app/main.dart';
import 'package:flutter/foundation.dart';

void main() {
  final config = AppFlavour.fromAppMode(FrappeAppMode.vaidyagrama);
  debugPrint('config:$config');
  mainApp(config);
}
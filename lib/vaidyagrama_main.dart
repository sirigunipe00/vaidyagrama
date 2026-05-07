import 'package:app/core/utils/app_flavor.dart';
import 'package:app/main.dart';

void main() {
   print('config:SIRI');
  final config = AppFlavour.fromAppMode(FrappeAppMode.vaidyagrama);
  print('config:$config');
  mainApp(config);
}
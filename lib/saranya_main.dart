import 'package:app/core/utils/app_flavor.dart';
import 'package:app/main.dart';

void main() {
  final config = AppFlavour.fromAppMode(FrappeAppMode.saranya);
  mainApp(config);
}
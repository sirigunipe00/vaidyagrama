

import 'package:app/styles/app_icons.dart';

enum FrappeAppMode { vaidyagrama, saranya }

class AppFlavour {

  const AppFlavour({required this.logo, required this.mode, required this.appName});

  factory AppFlavour.fromAppMode(FrappeAppMode mode) {
    print('mode:$mode');
    return switch(mode) {
      FrappeAppMode.vaidyagrama => AppFlavour(appName: 'Vaidyagrama', logo: AppIcons.vaidyagrama.path, mode: mode),
      FrappeAppMode.saranya => AppFlavour(appName: 'Saranya', logo: AppIcons.saranya.path, mode: mode),

    };
  }
  final String logo;
  final String appName;
  final FrappeAppMode mode;

  @override
  String toString() {
    return 'AppFlavour( appName:$appName , logo:$logo , FrappeAppMode : ${mode.name} )';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';

class AppIcons {
  static const basePath = 'assets';
  static const imagesPath = '$basePath/images';
  static const iconsPath = '$basePath/logo';
  static const bgFrame1 = AppIcon('$imagesPath/bg_frame_2.png');
  static const saranya = AppIcon('$imagesPath/saranya.png');
  static const vaidyagrama = AppIcon('$imagesPath/vaidyagramalogo.png');


  static const shaktiHormannLogo = AppIcon('$iconsPath/hormann-logo-new-1 1.png');

  // static const bubbles = AppIcon('$imagesPath/bubbles.svg');

  static const task = AppIcon('$imagesPath/task1.png');
  static const loading = AppIcon('$imagesPath/loading2.png');
  static const orderDelivery = AppIcon('$imagesPath/delivery1.png');
  static const inward = AppIcon(
    '$imagesPath/inward1.png',
  );
  static const vehicleReporting = AppIcon('$imagesPath/vehiclereportings.svg');
  static const loadingConfirmation = AppIcon('$imagesPath/loadingconfirmation.svg');
  static const pod = AppIcon('$imagesPath/pod.svg');
  static const helloCuate = AppIcon('$imagesPath/hello_cuate.svg');
  static const settingsCuate = AppIcon('$imagesPath/settings_cuate.svg');

 

}

class AppIcon {
  const AppIcon(this.path);

  final String path;

  Widget toWidget({
    double width = 60,
    double height = 30,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    final fileextension = extension(path);
    if (fileextension == '.svg') {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: fit,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }
}

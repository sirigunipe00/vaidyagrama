import 'package:flutter/material.dart';
import 'package:vaidyagrama/features/auth/model/logged_in_user.dart';
import 'package:vaidyagrama/styles/app_icons.dart';


class DashboardItem {

  const DashboardItem({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.permissionSelector,
  });
  final String title;
  final AppIcon icon;
  final void Function(BuildContext context) onTap;
  final int? Function(RoleStatus? roleStatus) permissionSelector;
}

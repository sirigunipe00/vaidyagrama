


import 'dart:math' as math;

import 'package:app/app/presentation/widgets/app_page_view.dart';
import 'package:app/app/presentation/widgets/app_page_view2.dart';
import 'package:app/styles/app_color.dart';
import 'package:app/styles/app_text_styles.dart';
import 'package:app/widgets/app_spacer.dart';
import 'package:app/widgets/buttons/app_btn.dart';
import 'package:app/widgets/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app/core/core.dart';

import 'package:app/features/auth/presentation/bloc/auth/auth_cubit.dart';

class AppProfilePage extends StatelessWidget {
  const AppProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.user.roleProfileName;

    return AppPageView(
      mode: PageMode.profile, 
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24),
        child: SpacedColumn(
          defaultHeight: 0,
          divider: Divider(color: AppColors.grey.shade400),
          children: [
            _ProfileItem(
              const Icon(Icons.person_2_rounded, color: AppColors.lavender), 
              'Name', 
              context.user.name,
            ),
            _ProfileItem(
              const Icon(Icons.business, color: AppColors.lavender), 
              'Organization', 
              role.containsValidValue ? role! : context.appFlavor.appName.toUpperCase(),
            ),
            
            FutureBuilder(
              future: _appversion(),
              builder: (_, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  final version = snapshot.data!;
                  return _ProfileItem(
                    const Icon(Icons.phone_iphone_outlined, color: AppColors.lavender), 
                    'App Version', 
                    version,
                  );
                }
                return const SizedBox();
              },
            ),

            AppButton(
              label: 'Logout',
              margin: const EdgeInsets.all(12.0),
              icon: Transform.rotate(
                angle: 180 * math.pi / 180,
                child: const Icon(Icons.logout_outlined, color: AppColors.white),
              ),
              onPressed: context.cubit<AuthCubit>().signOut,
            ),
          ],
        ),
      )
    );
  }

  Future<String> _appversion() async {
    final pinfo = await PackageInfo.fromPlatform();
    final version = pinfo.version;
    final buildNumber = pinfo.buildNumber;
    return '$version ($buildNumber)';
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem(this.icon, this.title, this.value);

  final Widget icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.white, child: icon),
          AppSpacer.p8(),
          Text(title, style: AppTextStyles.titleLarge(context).copyWith(color: AppColors.black)),
          const Spacer(),
          Text(value, style: AppTextStyles.titleLarge(context).copyWith(color: AppColors.grey)),
        ],
      ),
    );
  }
}
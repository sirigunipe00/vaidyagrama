
import 'package:app/app/presentation/widgets/app_page_view.dart';
import 'package:app/core/core.dart';
import 'package:app/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/app/presentation/bloc/app_update_bloc_provider.dart';
import 'package:app/styles/app_color.dart';
import 'package:app/styles/app_icons.dart';
import 'package:app/widgets/app_feature_widget.dart';
import 'package:app/widgets/app_update_dailog.dart';

class AppHomePage extends StatelessWidget {
  const AppHomePage({super.key});



  @override
  Widget build(BuildContext context) {
// final userRoles = context.user.roleStatus;
    return AppPageView( mode: PageMode.home,
    child: 
     BlocListener<AppVersionCubit, AppVersionCubitState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            success: (data) {
              if (data) {
                showDialog(
                  context: context,
                  builder: (ctx) => AppUpdateDialog(
                    appName: context.appFlavor.appName.toUpperCase(),
                    packageName:
                        context.appFlavor.appName.toUpperCase() == 'Vaidyagrama'
                            ? 'in.easycloud.vaidyagrama'
                            : 'in.easycloud.saranya'),
                  barrierDismissible: false,
                );
              }
            },
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (userRoles == null)
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     "${context.user.name} does not have access to view the features.",
              //     style: AppTextStyles.featureLabelStyle(context).copyWith(
              //       color: Colors.red,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            // if (userRoles != null) ...[
              GridView.count(
                padding: const EdgeInsets.all(12.0),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1,
                children: [
                  // if (BooleanUtls.fromInt(userRoles.showLoading))
                    AppFeatureWidget(
                      icon: AppIcons.task.toWidget(
                          height: 80, width: 80, fit: BoxFit.contain),
                      title: Text('Task',
                          style: AppTextStyles.featureLabelStyle(context)),
                      featureColor: AppColors.white,
                      onTap: () => AppRoute.task.push(context),
                    ),
                  // if (BooleanUtls.fromInt(userRoles.exit))
                  //   AppFeatureWidget(
                  //     icon: AppIcons.vehcileExit.toWidget(
                  //         height: 100, width: 120, fit: BoxFit.contain),
                  //     title: Text('Gate Exit',
                  //         style: AppTextStyles.featureLabelStyle(context)),
                  //     featureColor: AppColors.shyMoment,
                  //     onTap: () => AppRoute.gateExit.push(context),
                  //   ),
                  // if (BooleanUtls.fromInt(userRoles.registration))
                  //   AppFeatureWidget(
                  //     icon: AppIcons.registration.toWidget(
                  //         height: 100, width: 120, fit: BoxFit.contain),
                  //     title: FittedBox(
                  //       child: Text('Visitors Registration',
                  //           style:
                  //               AppTextStyles.featureLabelStyle(context)),
                  //     ),
                  //     featureColor: AppColors.registration,
                  //     onTap: () => AppRoute.gateRegistration.push(context),
                  //   ),
                  //   if(context.appFlavor.appName == 'HTPL')...[
                  //        if (BooleanUtls.fromInt(userRoles.gaylord))
                  //   AppFeatureWidget(
                  //     icon: AppIcons.gayLord.toWidget(
                  //         height: 100, width: 120, fit: BoxFit.fill),
                  //     title: FittedBox(
                  //       child: Text('Dispatch Gaylord',
                  //           style:
                  //               AppTextStyles.featureLabelStyle(context)),
                  //     ),
                  //     featureColor: AppColors.dispatch,
                  //     onTap: () {
                  //       // AppRoute.dipatchGaylord.push(context);
                  //     },
                  //   ),
              
                  //   ],
               
                  // if (BooleanUtls.fromInt(userRoles.approval))
                  //   AppFeatureWidget(
                  //     icon: FittedBox(
                  //       child: AppIcons.poApproval.toWidget(
                  //           height: 100, width: 120, fit: BoxFit.contain),
                  //     ),
                  //     title: FittedBox(
                  //       child: Text('PO Approval List',
                  //           style:
                  //               AppTextStyles.featureLabelStyle(context)),
                  //     ),
                  //     featureColor: const Color(0xFF0DB295),
                  //     onTap: () => AppRoute.poApprovalList.push(context),
                  //   ),
                  // if (BooleanUtls.fromInt(userRoles.dashbaords))
                  //   AppFeatureWidget(
                  //     icon: AppIcons.dashboards.toWidget(
                  //         height: 100, width: 120, fit: BoxFit.fill),
                  //     title: Text('Dashboard',
                  //         style: AppTextStyles.featureLabelStyle(context)),
                  //     featureColor: AppColors.dashboard,
                  //     onTap: () => AppRoute.dashboards.push(context),
                  //   ),
                ],
              ),
            ],
          // ],
        ),
      ),
    );
  }
}

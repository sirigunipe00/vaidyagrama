// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:vaidyagrama/app/presentation/bloc/app_update_bloc_provider.dart';
// import 'package:vaidyagrama/app/presentation/widgets/dashboard_item.dart';
// import 'package:vaidyagrama/app/presentation/widgets/greeting_widget.dart';
// import 'package:vaidyagrama/core/app_router/app_route.dart';
// import 'package:vaidyagrama/core/di/injector.dart';
// import 'package:vaidyagrama/features/auth/model/logged_in_user.dart';
// import 'package:vaidyagrama/styles/app_icons.dart';
// import 'package:vaidyagrama/widgets/app_update_dailog.dart';

// class AppHomePage extends StatefulWidget {
//   const AppHomePage({super.key});

//   @override
//   State<AppHomePage> createState() => _AppHomePageState();
// }

// class _AppHomePageState extends State<AppHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//         statusBarBrightness: Brightness.light,
//       ),
//     );
//   }

//   final List<DashboardItem> dashboardItems = [
//     DashboardItem(
//       title: 'Gate Entry',
//       icon: AppIcons.gateeEntry,
//       onTap: (context) {
//         AppRoute.gateEntry.push<bool?>(context);
//       },
//       permissionSelector: (roleStatus) => roleStatus?.showGateEntry,
//     ),
//     DashboardItem(
//       title: 'Gate Exit',
//       icon: AppIcons.gateExit,
//       onTap: (context) {
//         AppRoute.gatexit.push<bool?>(context);
//       },
//       permissionSelector: (roleStatus) => roleStatus?.showGateExit,
//     ),
//     DashboardItem(
//       title: 'Logistic Request',
//       icon: AppIcons.logisticRequest,
//       onTap: (context) {
//         AppRoute.logisticRequest.push<bool?>(context);
//       },
//       permissionSelector: (roleStatus) => roleStatus?.showLogisticRequest,
//     ),
//     DashboardItem(
//       title: 'Transport\nConfirmation',
//       icon: AppIcons.transportrterConfirmation,
//       onTap: (context) {
//         AppRoute.transportConfirmation.push<bool?>(context);
//       },
//       permissionSelector:
//           (roleStatus) => roleStatus?.showTransporterConfirmation,
//     ),
//     DashboardItem(
//       title: 'Vehicle Reporting\nEntry',
//       icon: AppIcons.vehicleReporting,
//       onTap: (context) {
//         AppRoute.vehcileReporting.push<bool?>(context);
//       },
//       permissionSelector: (roleStatus) => roleStatus?.showVehicleReporting,
//     ),
//     DashboardItem(
//       title: 'Dispatch\nLoading',
//       icon: AppIcons.loadingConfirmation,
//       onTap: (context) {
//         AppRoute.loadingConfirmation.push<bool?>(context);
//       },
//       permissionSelector: (roleStatus) => roleStatus?.showLoadingConfirmation,
//     ),
//     DashboardItem(
//       title: 'Proof Of Delivery',
//       icon: AppIcons.pod,
//       onTap: (context) {
//         AppRoute.proofOfDelivery.push<bool?>(context);
//       },
//       permissionSelector: (roleStatus) => roleStatus?.showpod,
//     ),
//   ];

//   Widget buildDashboardCard(DashboardItem item) {
//     return GestureDetector(
//       onTap: () => item.onTap(context),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),

//           color: Colors.white,
//           border: Border.all(color: const Color(0xFFE8ECF4), width: 2),
//           boxShadow: [
//             const BoxShadow(
//               color: Color(0xFFFFFFFF),
//               blurRadius: 5,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             item.icon.toWidget(height: 60, width: 100),
//             const SizedBox(height: 10),
//             Text(
//               item.title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//                 fontFamily: 'Urbanist',
//                 color: Color(0xFF0E1446),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     LoggedInUser? user;
//     try {
//       user = $sl<LoggedInUser>();
//     } catch (_) {
//       user = null;
//     }

//     final roleStatus = user?.roleStatus;

//     final visibleItems =
//         dashboardItems
//             .where((item) => item.permissionSelector(roleStatus) == 1)
//             .toList();
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       body: SafeArea(
//         child: BlocListener<AppVersionCubit, AppVersionCubitState>(
//           listener: (context, state) {
//            state.maybeWhen(
//             orElse: () {},
//             success: (data) {
//               if (data) {
//                 showDialog(
//                     context: context,
//                     builder: (ctx) => const AppUpdateDialog(
//                         appName: 'ShaktiHormann',
//                         packageName: 'in.easycloud.shakti_hormann'),
//                     barrierDismissible: false);
//               }
//             },
//           );
//           },
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const GreetingHeader(),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 20),
//                       child: GestureDetector(
//                         // onTap: () => AppRoute.notifications.push(context),
//                         child: Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity( 0.05),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               Center(
//                                 child: SvgPicture.asset(
//                                   'assets/images/notification.svg',
//                                   height: 24,
//                                   width: 24,
//                                 ),
//                               ),
//                               Positioned(
//                                 top: -2,
//                                 right: -2,
//                                 child: Container(
//                                   width: 12,
//                                   height: 12,
//                                   decoration: BoxDecoration(
//                                     color: Colors.redAccent,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: Colors.white,
//                                       width: 0.5,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // const TaskWidget(
//               //   title: "Your Today's Task",
//               //   subtitle: 'Almost done!',
//               //   icon: Icons.check_circle,
//               //   onCancel: null,
//               // ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: GridView.builder(
//                     itemCount: visibleItems.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 1,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                         ),
//                     itemBuilder: (context, index) {
//                       return buildDashboardCard(visibleItems[index]);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaidyagrama/app/presentation/bloc/app_update_bloc_provider.dart';
import 'package:vaidyagrama/core/app_router/app_route.dart';
import 'package:vaidyagrama/core/di/injector.dart';
import 'package:vaidyagrama/features/auth/model/logged_in_user.dart';
import 'package:vaidyagrama/styles/app_color.dart';
import 'package:vaidyagrama/styles/app_icons.dart';
import 'package:vaidyagrama/widgets/app_feature_widget.dart';
import 'package:vaidyagrama/widgets/app_update_dailog.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }


  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning 🌄';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon 🌞';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening 🌆';
    } else {
      return 'Good Night 🌉';
    }
  }

  // Get user name from API
  String _getUserName(LoggedInUser? user) {
    if (user == null) return 'User';
    return user.fullName?.isNotEmpty == true
        ? user.fullName!
        : (user.name.isNotEmpty
            ? user.name
            : (user.firstName?.isNotEmpty == true ? user.firstName! : 'User'));
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser? user;
    try {
      user = $sl<LoggedInUser>();
    } catch (_) {
      user = null;
    }
    final roleStatus = user?.roleStatus;
    final userName = _getUserName(user);
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: BlocListener<AppVersionCubit, AppVersionCubitState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (data) {
                  if (data) {
                    showDialog(
                      context: context,
                      builder: (ctx) => const AppUpdateDialog(
                        appName: 'Scoops',
                        packageName: 'in.easycloud.vaidyagrama',
                      ),
                      barrierDismissible: false,
                    );
                  }
                },
              );
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$greeting, $userName',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Let's Scoop Up a Productive day!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.3,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GridView.count(
                  padding: const EdgeInsets.all(12.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1,
                  children: [
                    if ((roleStatus?.showLogistic ?? 0) == 1)
                      AppFeatureWidget(
                        icon: AppIcons.logistic.toWidget(
                            height: 200, width: 180, fit: BoxFit.contain),
                        title: const FittedBox(),
                        permissionSelector: (roleStatus) =>
                            roleStatus?.showLogistic,
                        // Text('Logistic Booking',
                        //     style: AppTextStyles.featureLabelStyle(context)),
                        featureColor: AppColors.white,
                        onTap: () => AppRoute.logistic.push(context),
                      ),
                    if ((roleStatus?.showLoading ?? 0) == 1)
                      AppFeatureWidget(
                        icon: AppIcons.loading.toWidget(
                            height: 200, width: 180, fit: BoxFit.contain),
                        title: const FittedBox(),
                        permissionSelector: (roleStatus) =>
                            roleStatus?.showLoading,
                        // title: Text('Loading',
                        //     style: AppTextStyles.featureLabelStyle(context)),
                        featureColor: AppColors.white,
                        onTap: () => AppRoute.loading.push(context),
                      ),
                    if ((roleStatus?.showDispatch ?? 0) == 1)
                      AppFeatureWidget(
                        icon: AppIcons.orderDelivery.toWidget(
                            height: 200, width: 180, fit: BoxFit.contain),
                        title: const FittedBox(),
                        // child: Text('Order Delivery',
                        //     style: AppTextStyles.featureLabelStyle(context)),

                        permissionSelector: (roleStatus) =>
                            roleStatus?.showDispatch,
                        featureColor: Colors.white,
                        onTap: () => AppRoute.orderDelivery.push(context),
                      ),
                    if ((roleStatus?.showInward ?? 0) == 1)
                      AppFeatureWidget(
                        icon: AppIcons.inward.toWidget(height: 200, width: 180),
                        title: const FittedBox(),
                        // Text('Crate Inward',
                        //     style: AppTextStyles.featureLabelStyle(context)),
                        featureColor: AppColors.white,
                        permissionSelector: (roleStatus) =>
                            roleStatus?.showInward,
                        onTap: () => AppRoute.createInward.push(context),
                      ),
                  ],
                ),
                // const SizedBox(height: 50),

                // Container(
                //   width: double.infinity,
                //   height: 180,
                //   padding: const EdgeInsets.symmetric(
                //     vertical: 16,
                //     horizontal: 14,
                //   ),
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(255, 225, 225, 225),
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.05),
                //         blurRadius: 6,
                //         offset: const Offset(0, 3),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [

                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             'App from Scoops',
                //             style: TextStyle(
                //               fontSize: 28,
                //               fontWeight: FontWeight.w600,
                //               color: Color.fromARGB(255, 147, 147, 147),
                //               fontFamily: 'Urbanist',
                //             ),
                //             textAlign: TextAlign.start,
                //           ),
                //           const SizedBox(height: 4),
                //           Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               const Text(
                //                 'trusted platform',
                //                 style: TextStyle(
                //                   fontSize: 28,
                //                   fontWeight: FontWeight.w600,
                //                   color: Color.fromARGB(255, 147, 147, 147),
                //                   fontFamily: 'Urbanist',
                //                 ),
                //               ),
                //               Image.asset(
                //                 'assets/images/heart.png',
                //                 height: 36,
                //                 width: 36,
                //                 fit: BoxFit.contain,
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),

                //       const SizedBox(height: 32),

                //       const Row(
                //         children: [
                //           Text(
                //             'Easy',
                //             style: TextStyle(
                //               fontSize: 20,
                //               fontWeight: FontWeight.w500,
                //               color: Color.fromARGB(255, 147, 147, 147),
                //               fontFamily: 'Urbanist',
                //             ),
                //             textAlign: TextAlign.start,
                //           ),
                //           Text(
                //             'Cloud',
                //             style: TextStyle(
                //               fontSize: 20,
                //               fontWeight: FontWeight.w800,
                //               color: Color.fromARGB(255, 147, 147, 147),
                //               fontFamily: 'Urbanist',
                //             ),
                //             textAlign: TextAlign.start,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

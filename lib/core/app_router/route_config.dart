import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/app/presentation/bloc/app_update_bloc_provider.dart';
import 'package:app/app/presentation/ui/app_home_page.dart';
import 'package:app/app/presentation/ui/app_profile_page.dart';
import 'package:app/app/presentation/widgets/app_scaffold_widget.dart';
import 'package:app/core/app_router/app_route.dart';
import 'package:app/core/consts/messages.dart';
import 'package:app/core/utils/typedefs.dart';
import 'package:app/features/auth/presentation/ui/authentication_scrn.dart';
import 'package:app/widgets/dailogs/app_dialogs.dart';



class AppRouterConfig {
  static final parentNavigatorKey = GlobalKey<NavigatorState>();

  static int dashboardStatus = 0;

  static void setDashboardStatus(int status) {
    dashboardStatus = status;
  }

  static final GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: AppRoute.home.path,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.home.path,
        builder: (_, state) => const AppHomePage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffoldWidget(navigationShell: navigationShell);
          // LoggedInUser? loggedInUser;

          // try {
          //   loggedInUser =
          //       $sl.isRegistered<LoggedInUser>() ? $sl<LoggedInUser>() : null;
          // } catch (_) {
          //   loggedInUser = null;
          // }

          // // final roleStatus = loggedInUser?.roleStatus;
          // // AppRouterConfig.setDashboardStatus(
          // //   roleStatus?.showDashboards == 1 ? 1 : 0,
          // // );

          // return AppScaffoldWidget(
          //   navigationShell: navigationShell,
          //   roleStatus: roleStatus,
          // );
        },

        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                builder:
                    (_, state) => BlocProvider(
                      create:
                          (_) =>
                              AppUpdateBlocprovider.get().appversionCubit()
                                ..request(),
                      child: const AppHomePage(),
                    ),
                routes: const [
                 
                  // GoRoute(
                  //   path: _getPath(AppRoute.logistic),
                  //   builder: (ctxt, state) {
                  //     final filters = Pair(
                  //       StringUtils.docStatusInt('Draft'),
                  //       null,
                  //     );
                  //     return BlocProvider(
                  //       create:
                  //           (context) =>
                  //               LogisticBlocProvider.get().fetchLogisticsCards()
                  //                 ..fetchInitial(filters),
                  //       child: const LogisticListScrn(),
                  //     );
                  //   },
                  //   routes: [
                  //     GoRoute(
                  //       path: _getPath(AppRoute.newLogistic),
                  //       onExit: (context, state) async {
                  //         final form = state.extra as LogisticsCard?;
                  //         final formStatus =
                  //             form?.docStatus == 1 ? 'Submitted' : 'Draft';
                  //         return await _promptConf(
                  //           context,
                  //           formStatus: formStatus,
                  //         );
                  //       },
                  //       builder: (_, state) {
                  //         final gateEntryForm = state.extra as LogisticsCard?;

                  //         return MultiBlocProvider(
                  //           providers: [
                  //             BlocProvider(
                  //               create:
                  //                   (_) =>
                  //                       LogisticBlocProvider.get()
                  //                           .getSales()
                  //                         ..request(gateEntryForm?.name ?? ''),
                  //             ),
                              
                  //             BlocProvider(
                  //               create:
                  //                   (_) =>
                  //                       LogisticBlocProvider.get()
                  //                           .getDriver()
                  //                         ..request(''),
                  //             ),
                  //             BlocProvider(
                  //               create:
                  //                   (_) =>
                  //                       LogisticBlocProvider.get()
                  //                           .getDriverList()
                  //                         ..request(''),
                  //             ),
                  //              BlocProvider(
                  //               create:
                  //                   (_) =>
                  //                       LogisticBlocProvider.get()
                  //                           .getVehicleList()
                  //                         ..request(''),
                  //             ),

                  //             BlocProvider(
                  //               create:
                  //                   (_) =>
                  //                       $sl.get<CreateLogisticCubit>()
                  //                         ..initDetails(gateEntryForm),
                  //             ),

                  //             BlocProvider(
                  //               create:
                  //                   (_) =>
                  //                       LogisticBlocProvider.get()
                  //                           .getSalesOrderList()
                  //                         ..request(gateEntryForm?.customerType ?? ''),
                  //             ),
                              
                  //           ],
                  //           child: const NewLogistic(),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // GoRoute(
                  //   path: _getPath(AppRoute.loading),
                  //   builder: (ctxt, state) {
                  //     final filters = Pair(
                  //       StringUtils.docStatusInt('Draft'),
                  //       null,
                  //     );
                  //     final gateEntryForm = state.extra as LogisticsCard?;
                  //     return 
                  //     MultiBlocProvider(
                  //       providers: [
                  //         BlocProvider(
                  //         create:
                  //             (context) =>
                  //                 LoadingBlocProvider.get().fetchLogisticsCards()
                  //                   ..fetchInitial(filters),
                  //         ),

                  //             BlocProvider(
                  //               create:
                  //                   (_) =>
                  //                       $sl.get<CreateLogisticCubit>()
                  //                         ..initDetails(gateEntryForm),
                  //             ),
                  //           BlocProvider(
                  //         create:
                  //             (context) =>
                  //                 LogisticBlocProvider.get().getSales()
                  //                   ..request(gateEntryForm?.name),
                  //         ),
                  //       ],
                  //       child: 
                  //         const LoadingScreen(),
                        
                  //     );
                  //   },
                  //   routes: [
                  //     GoRoute(
                  //       onExit: (context, state) async {
                  //         final form = state.extra as LogisticsCard?;
                  //         final formStatus =
                  //             form?.docStatus == 1 ? 'Submitted' : 'Draft';
                  //         return await _promptConf(
                  //           context,
                  //           formStatus: formStatus,
                  //         );
                  //       },
                  //       path: _getPath(AppRoute.newLoading),
                  //       builder: (_, state) {
                  //         final form = state.extra as LogisticsCard?;
                  //         return MultiBlocProvider(
                  //           providers: [
                  //                 BlocProvider(
                  //         create:
                  //             (context) =>
                  //                 LogisticBlocProvider.get().getSales()
                  //                   ..request(form?.name),
                  //         ),
                            
                  //           ],
                  //           ch
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // GoRoute(
                  //   path: _getPath(AppRoute.orderDelivery),
                  //   builder: (ctxt, state) {
                      
                  //     return 
                  //     BlocProvider(
                  //       create:
                  //           (context) =>
                  //               DispatchBlocProvider.get()
                  //                   .getDisptachDetailsBloc()
                  //                 ..request(),
                  //       child: const DispatchScreen(),
                  //     );
                  //   },
              //       routes: [
              //         GoRoute(
              //           path: _getPath(AppRoute.newLogisticRequest),
              //           onExit: (context, state) async {
              //             final form = state.extra as LogisticPlanningForm?;
              //             final formStatus =
              //                 form?.docstatus == 1 ? 'Submitted' : 'Draft';
              //             return _promptConf(context, formStatus: formStatus);
              //           },
              //           builder: (_, state) {
              //             final bloc = LogisticPlanningBlocProvider.get();
              //             final logisticForm =
              //                 state.extra as LogisticPlanningForm?;
              //             return MultiBlocProvider(
              //               providers: [
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           $sl.get<CreateLogisticCubit>()
              //                             ..initDetails(logisticForm),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) => bloc.salesOrderList()..request(''),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) => bloc.transportersList()..request(''),
              //                 ),
              //                 BlocProvider(
              //                   create: (_) => bloc.vehicleList()..request(''),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           bloc.salesList()
              //                             ..request(logisticForm?.name ?? ''),
              //                 ),
              //               ],
              //               child: const NewLogisticRequest(),
              //             );
              //           },
              //         ),
              //       ],
                  // ),
                  // GoRoute(
                  //   path: _getPath(AppRoute.createInward),
                  //   builder: (ctxt, state) {
                      // final filters = Pair(
                      //   StringUtils.docStatuslogistic(
                      //     'Pending From Transporter',
                      //   ),
                      //   null,
                      // );
                      // return const InwardScreen();
                      // BlocProvider(
                      //   create:
                      //       (context) =>
                      //           TransportCnfmBlocProvider.get().fetchTransport()
                      //             ..fetchInitial(filters),
                      //   child: const TransportCnfmList(),
                      // );
                    // },
              //       routes: [
              //         GoRoute(
              //           path: _getPath(AppRoute.newTarnsportCnfrm),
              //           onExit: (context, state) async {
              //             final form =
              //                 state.extra as TransportConfirmationForm?;
              //             final formStatus =
              //                 form?.docstatus == 1 ? 'Submitted' : 'Draft';
              //             return _promptConf(context, formStatus: formStatus);
              //           },
              //           builder: (_, state) {
              //             final bloc = LogisticPlanningBlocProvider.get();

              //             final form = state.extra;
              //             final logisticform =
              //                 state.extra as TransportConfirmationForm?;

              //             return MultiBlocProvider(
              //               providers: [
              //                 BlocProvider(
              //                   create:
              //                       (_) => bloc.transportersList()..request(''),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           bloc.salesList()
              //                             ..request(logisticform?.name ?? ''),
              //                 ),

              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           $sl.get<CreateLogisticCubit>()
              //                             ..initDetails(logisticform),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           $sl.get<CreateTransportCubit>()
              //                             ..initDetails(form),
              //                 ),
              //               ],
              //               child: const NewTransportCnfm(),
              //             );
              //           },
              //         ),
              //       ],
                  // ),
              //     GoRoute(
              //       path: _getPath(AppRoute.vehcileReporting),
              //       builder: (ctxt, state) {
              //         final filters = Pair(
              //           StringUtils.docStatusVehicle('Draft'),
              //           null,
              //         );
              //         return BlocProvider(
              //           create:
              //               (context) =>
              //                   VehicleBlocProvider.get().fetchVehicle()
              //                     ..fetchInitial(filters),
              //           child: const VehicleReportingList(),
              //         );
              //       },
              //       routes: [
              //         GoRoute(
              //           path: _getPath(AppRoute.newVehiclereporting),
              //           onExit: (context, state) async {
              //             final form = state.extra as VehicleReportingForm?;
              //             final formStatus =
              //                 form?.docstatus == 1 ? 'Submitted' : 'Reported';
              //             return _promptConf(context, formStatus: formStatus);
              //           },
              //           builder: (_, state) {
              //             final bloc = VehicleBlocProvider.get();
              //             final blocprovider =
              //                 LogisticPlanningBlocProvider.get();
              //             final form = state.extra;
              //             return MultiBlocProvider(
              //               providers: [
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           $sl.get<CreateVehicleCubit>()
              //                             ..initDetails(form),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           blocprovider.transportersList()
              //                             ..request(''),
              //                 ),
              //                 BlocProvider(
              //                   create: (_) => bloc.logisticList()..request(''),
              //                 ),
              //               ],
              //               child: const NewVehicleReporting(),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //     GoRoute(
              //       path: _getPath(AppRoute.loadingConfirmation),
              //       builder: (ctxt, state) {
              //         final filters = Pair(
              //           StringUtils.docStatusVehicle('Reported'),
              //           null,
              //         );
              //         return BlocProvider(
              //           create:
              //               (context) =>
              //                   LoadingCnfmBlocProvider.get()
              //                       .fetchLoadingCnfmList()
              //                     ..fetchInitial(filters),
              //           child: const LoadingCnfrmList(),
              //         );
              //       },
              //       routes: [
              //         GoRoute(
              //           path: _getPath(AppRoute.newLoadingConfirmation),
              //           onExit: (context, state) async {
              //             final form = state.extra as LoadingCnfmForm?;
              //             final formStatus =
              //                 form?.docstatus == 1 ? 'Submitted' : 'Reported';
              //             return _promptConf(context, formStatus: formStatus);
              //           },
              //           builder: (_, state) {
              //             final blocprovider = LoadingCnfmBlocProvider.get();
              //             final form = state.extra as LoadingCnfmForm;
              //             // final forms = state.extra as LogisticModel;
              //             return MultiBlocProvider(
              //               providers: [
              //                 BlocProvider(
              //                   create:
              //                       (_) => blocprovider.fetchLoadingCnfmList(),
              //                 ),
              //                 BlocProvider(
              //                   create: (_) => blocprovider.itemList(),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           blocprovider.getItems()
              //                             ..request(form.name ?? ''),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           blocprovider.getLogisticList()
              //                             ..request(form.name ?? ''),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           $sl.get<CreateLoadingCnfmCubit>()
              //                             ..initDetails(form),
              //                 ),
              //               ],
              //               child: const NewLoadingConfirmation(),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //     GoRoute(
              //       path: _getPath(AppRoute.proofOfDelivery),
              //       builder: (ctxt, state) {
              //         final filters = Pair(
              //           StringUtils.docStatusInt('Draft'),
              //           null,
              //         );
              //         return BlocProvider(
              //           create:
              //               (context) =>
              //                   ProofOfDeliveryBlocProvider.get()
              //                       .fetchProofOfDelivery()
              //                     ..fetchInitial(filters),
              //           child: const PodListScrn(),
              //         );
              //       },
              //       routes: [
              //         GoRoute(
              //           path: _getPath(AppRoute.newproofOfDelivery),
              //           onExit: (context, state) async {
              //             final form = state.extra as ProofOfDelivery?;
              //             final formStatus =
              //                 form?.docStatus == 1 ? 'Submitted' : 'Reported';
              //             return _promptConf(context, formStatus: formStatus);
              //           },
              //           builder: (_, state) {
              //             final blocprovider =
              //                 ProofOfDeliveryBlocProvider.get();
              //             final form = state.extra as ProofOfDelivery?;
              //             return MultiBlocProvider(
              //               providers: [
              //                 BlocProvider(
              //                   create:
              //                       (_) => blocprovider.fetchProofOfDelivery(),
              //                 ),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           blocprovider.salesInvoiceList()
              //                             ..request(''),
              //                 ),
              //                 // BlocProvider(create: (_)=> blocprovider.getItems()..request(form.name ?? '')),
              //                 BlocProvider(
              //                   create:
              //                       (_) =>
              //                           $sl.get<CreatePodCubit>()
              //                             ..initDetails(form),
              //                 ),
              //               ],
              //               child: const NewPod(),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
                ],
              ),
            ],
          ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: AppRoute.dashboard.path,
          //       redirect:
          //           (_, __) => dashboardStatus == 1 ? null : AppRoute.home.path,
          //       builder: (_, __) => const AppDashboardPage(),
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.account.path,
                builder: (_, __) => const AppProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static Future<bool> _promptConf(
    BuildContext context, {
    required String formStatus,
  }) async {
    final promptConf = shouldAskForConfirmation.value;
    if (!promptConf) return true;
    if (formStatus == 'Submitted') {
      return true;
    }
    final result = await AppDialog.askForConfirmation<bool?>(
      context,
      title: 'Are you sure?',
      confirmBtnText: 'Yes',
      content: Messages.clearConfirmation,
      onTapConfirm: () => context.pop(true),
      onTapDismiss: () => context.pop(false),
    );
    return result ?? false;
  }

  static String _getPath(AppRoute route) => route.path.split('/').last;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:app/features/auth/presentation/ui/sign_in/sign_in_cubit.dart';
import 'package:app/styles/material_theme.dart';
import 'package:app/widgets/inputs/flavor_banner.dart';



class FrappeApp extends StatelessWidget {
  const FrappeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => $sl.get<AuthCubit>()..authCheckRequested()),
        BlocProvider<SignInCubit>(create: (_) => $sl.get<SignInCubit>()),
        // BlocProvider(create: (_) => GateEntryFilterCubit()),
        // BlocProvider(create: (_) => GateExitFilterCubit()),
        // BlocProvider(create: (_) => GateRegistrationFilterCubit()),
        // BlocProvider(create: (_) => PoApprovalFiltersCubit()),
        // BlocProvider(create: (_) => DispatchGaylordFilterCubit()),
        // BlocProvider(
        //   create: (_) => GateEntryBlocProvider.get().createGateEntriesCubit()),
        // BlocProvider(
        //   create: (_) => GateExitBlocProvider.get().createGateExitsCubit()),
        // BlocProvider(
        //   create: (_) => GateRegistrationBlocProvider.get().createGateRegistrationsCubit()),
        // BlocProvider(create: (_) => PoApprovalBlocProvider.get().fetchPurchaseOrders()),
        // BlocProvider(create: (_) => DispatchBlocProvider.get().fetchGaylords()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (_, state) {
          final routerCtxt = AppRouterConfig.parentNavigatorKey.currentContext!;
          state.maybeWhen(
            orElse: () => AppRoute.initial.go(routerCtxt),
            authenticated: () {
              // routerCtxt
              //   ..cubit<GateEntriesCubit>().fetchInitial(PageListFilters.initial())
              //   ..cubit<GateExitsCubit>().fetchInitial(PageListFilters.initial())
              //   ..cubit<GateRegistrationsCubit>().fetchInitial(PageListFilters.initial())
              //   ..cubit<DispatchCubit>().fetchInitial(PageListFilters.initial())
              //   ..cubit<PoApprovalCubit>().fetchInitial(PageListFilters.initial());
              AppRoute.home.go(routerCtxt);
            },
            unAuthenticated: () => AppRoute.login.go(routerCtxt),
          );
        },
        child: FlavorBanner(
          child: MaterialApp.router(
            title: context.appFlavor.appName,
            theme: AppMaterialTheme.lightTheme,
            darkTheme: AppMaterialTheme.lightTheme,
            routerConfig: AppRouterConfig.router,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

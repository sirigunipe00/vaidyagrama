import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaidyagrama/core/app_router/app_route.dart';
import 'package:vaidyagrama/core/app_router/route_config.dart';
import 'package:vaidyagrama/core/di/injector.dart';
import 'package:vaidyagrama/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:vaidyagrama/features/auth/presentation/ui/sign_in/sign_in_cubit.dart';
import 'package:vaidyagrama/styles/material_theme.dart';


class Vaidyagrama extends StatelessWidget {
  const Vaidyagrama({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => $sl.get<AuthCubit>()..authCheckRequested()),
        BlocProvider(create: (_) => $sl.get<SignInCubit>()),
        // BlocProvider(create: (_) => LogisticFilterCubit()),
        


        // BlocProvider(
        //   create: (_) => LogisticBlocProvider.get().fetchLogisticsCards(),
        // ),
      
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (_, state) {
          final routerCtxt = AppRouterConfig.parentNavigatorKey.currentContext;
          if (routerCtxt == null) return;
          state.maybeWhen(
            authenticated: () {
              // final filters = Pair(StringUtils.docStatusInt('Draft'), null);


              
              // routerCtxt.cubit<LogisticsCardsCubit>().fetchInitial(filters);



              AppRoute.home.go(routerCtxt);
            },
            unAuthenticated: () {
              AppRoute.login.go(routerCtxt);
            },
            orElse: () {
              AppRoute.login.go(routerCtxt);
            },
          );
        },
        builder: (_, state) {
           return MaterialApp.router(
            title: 'Scoops App',
            theme: AppMaterialTheme.lightTheme,
            darkTheme: AppMaterialTheme.lightTheme,
            routerConfig: AppRouterConfig.router,
            debugShowCheckedModeBanner: false,
          );
          
        },
      ),
    );
  }
}

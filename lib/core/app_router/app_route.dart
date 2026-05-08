import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class _AppRoutePaths {
  static const initial = '/';
  static const login = '/login';
  static const home = '/home';
  static const account = '/account';
  static const dashboard = '/dashboard';
  static const task='/home/task';
   static const loading='/home/loading';
  static const newlogistic ='/home/logistic/newlogistic';
  static const newLoading='/home/loading/newLoading';
  static const notifications='/home/notifications';
  static const orderDelivery='/home/orderDelivery';
  static const newOrderDelivery='/home/orderDelivery/neworderDelivery';
  static const crateInward='/home/crateInward';
  static const newcrateinward='/home/crateInward/newcrateInward';
  static const vehcileReporting='/home/vehiclereporting';
  static const newVehiclereporting='/home/vehiclereporting/newvehiclereporting';
  static const loadingConfirmation='/home/loadingConfirmation';
  // static const newloadingConfirmation='/home/loadingConfirmation/newLoadingConfirmation';
  static const proofOfDelivery ='/home/proofOfDelivery';
  static const newproofOfDelivery='/home/proofOfDelivery/newproofOfDelivery';
}

enum AppRoute {
  initial(_AppRoutePaths.initial),
  login(_AppRoutePaths.login),
  home(_AppRoutePaths.home),
  dashboard(_AppRoutePaths.dashboard),
  task(_AppRoutePaths.task),
  loading(_AppRoutePaths.loading),
  orderDelivery(_AppRoutePaths.orderDelivery),
  createInward(_AppRoutePaths.crateInward),

  newLogistic(_AppRoutePaths.newlogistic),
  newLoading(_AppRoutePaths.newLoading),
  neworderDelivery(_AppRoutePaths.newOrderDelivery),
  newcrateInward(_AppRoutePaths.newcrateinward),
  // newTarnsportCnfrm(_AppRoutePaths.newTarnsportCnfrm),
  newVehiclereporting(_AppRoutePaths.newVehiclereporting),
  newproofOfDelivery(_AppRoutePaths.newproofOfDelivery),
  account(_AppRoutePaths.account),
  // logisticRequest(_AppRoutePaths.logisticRequest),
  // transportConfirmation(_AppRoutePaths.transportConfirmation),
  vehcileReporting(_AppRoutePaths.vehcileReporting),
  loadingConfirmation(_AppRoutePaths.loadingConfirmation),
  proofOfDelivery(_AppRoutePaths.proofOfDelivery),
  notifications(_AppRoutePaths.notifications);

  

  const AppRoute(this.path);
  final String path;
}

extension AppRouteNavigation on AppRoute {
  void go(BuildContext context, {Object? extra}) {
    context.go(path, extra: extra);
  }

  void goNamed(BuildContext context, {Object? extra}) {
    context.goNamed(path, extra: extra);
  }

  Future<T?> push<T>(BuildContext context, {Object? extra}) async {
    return await context.push(path, extra: extra);
  }
}

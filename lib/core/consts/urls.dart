import 'package:app/core/di/injector.dart';

final _reqisteredUrl = $sl.get<Urls>(instanceName: 'baseUrl');

class Urls {

  factory Urls.saranyaUAT() =>const Urls('https://saranyauat.easycloud.co.in/api');
  factory Urls.saranyaLive() =>  const Urls('https://livescoops.easycloud.co.in/api');

  factory Urls.vaidyagramaUAT() =>const Urls('https://vaidyagramauat.easycloud.co.in/api');
  factory Urls.vaidyagramaLive() =>  const Urls('https://livescoops.easycloud.co.in/api');



  const Urls(this.url);


  static String filepath(String path) {
    return '${baseUrl.replaceAll('api', '')}/${path.replaceAll('/private', '').replaceAll("///", '/')}';
  }


  final String url;

  static bool get isTest => Uri.parse(
    _reqisteredUrl.url,
  ).authority.split('.').first.toLowerCase().contains('uat');
  static final baseUrl = _reqisteredUrl.url;
  static final jsonWs = '$baseUrl/resource';
  static final cusWs = '$baseUrl/method';

  static final getUsers = '$cusWs/vaidyagrama_app.mobile_app_api.getUsers';
  static final getList = '$cusWs/frappe.client.get_list';
  // static final getUsers = '$cusWs/shaktihormann.api.getUsers';


  //logistic Scoops Easycloud

  static final createLogistic = '$cusWs/scoops.api.create_logistic';
  static final submitLogistic = '$cusWs/scoops.api.submit_logistic';
  static final addItemsGetList = '$cusWs/scoops.custom_api.get_new_logistic_bookings';
  static final getLogisticsCards = '$cusWs/scoops.custom_api.get_logistics_list';
  static final getOrSaveEachLogisticsDetails = '$cusWs/scoops.custom_api.get_or_save_each_logistics_details';
  static final submitLogisticsDetails = '$cusWs/scoops.custom_api.submit_logistics';
  // static final saveLogisticsDetails = '$cusWs/scoops.custom_api.get_or_save_each_logistics_details';
  static final getLoadingsalesOrder = '$cusWs/scoops.custom_api.get_or_save_each_logistics_details';
    static final submitLoading = '$cusWs/scoops.api.submit_loading_details_json';

  static final getDeliveryDetailsFromSalesOrder = '$cusWs/scoops.custom_api.get_save_delivery_details_from_sales_order';
  static final saveLoadingKotDetails = '$cusWs/scoops.custom_api.get_save_delivery_details_from_sales_order';
  static final getDispatchDetails = '$cusWs/scoops.custom_api.get_logistics_list';
  static final getDispatchSalesOrders = '$cusWs/scoops.custom_api.get_or_save_each_logistics_details';
  static final sendOrResendDispatchOtp = '$cusWs/scoops.custom_api.send_or_resend_dispatch_otp';
  static final getOrderDispatchDetails = '$cusWs/scoops.custom_api.get_save_dipatch_details';
  static final submitDeliveryWithProofs = '$cusWs/scoops.custom_api.submit_delivery_with_proofs';
  static final damageCrateUpdate = '$cusWs/scoops.custom_api.damage_carate_update';
  static final damageProductUpdate = '$cusWs/scoops.custom_api.damage_product_update';
   static final submitTempearatureWithProof = '$cusWs/scoops.custom_api.update_temp_sales_order_wise';
  





  //inward

  static final getInwardDetails = '$cusWs/scoops.custom_api.get_logistics_list';
  static final getSalesDetails = '$cusWs/scoops.custom_api.get_or_save_each_logistics_details';
  static final validateOtp = '$cusWs/scoops.custom_api.validate_delivery_otp';

  static final getDeliveryNoteDetails = '$cusWs/scoops.custom_api.crate_inward_entry';

  static final getCrateInwardDetails = '$cusWs/scoops.custom_api.crate_inward_entry';






  
  static final logout = '$cusWs/scoops.overrides.logout';

  static final appVersion = '$cusWs/easy_common.api.get_app_version';

  static final companyName = '$jsonWs/Company';
  static final dashBoard = '$cusWs/shaktihormann.api.gate_dashboard';
  static final createGateEntry = '$cusWs/shaktihormann.api.createGateEntry';
  static final submitGateEntry = '$cusWs/shaktihormann.api.submit_gate_entry';
  static final createGateExit = '$cusWs/shaktihormann.api.create_gate_exit';
  static final submitGateExit = '$cusWs/shaktihormann.api.submit_gate_exit';
  static final createLogisticPlanning =
      '$cusWs/shaktihormann.api.create_logistic_planning';
  static final updateLogisticPlanning =
      '$cusWs/shaktihormann.api.update_logistic_planning';
  static final updateTransport='$cusWs/shaktihormann.api.update_logistic_transporter';
  static final createVehicleReporting='$cusWs/shaktihormann.api.create_vehicle_reporting';
  static final updateVehicleReporting = '$cusWs/shaktihormann.api.update_vehicle_reporting';
  static final createLoadingConfirmation ='$cusWs/shaktihormann.api.create_items_loaded';
  static final submitLoadingConfirmation = '$cusWs/shaktihormann.api.submit_vehicle_loading';
  static final getLodedItems = '$cusWs/shaktihormann.api.get_loaded_items';
  static final createproofOfDelivery = '$cusWs/shaktihormann.api.createProofOfDelivery';
  static final submitproofOfDelivery = '$cusWs/shaktihormann.api.submitProofOfDelivery';


}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/controllers/location_controller.dart';
import 'package:donmexapp/controllers/navigation_controller.dart';
import 'package:donmexapp/controllers/order_controller.dart';
import 'package:donmexapp/controllers/spots_controller.dart';
import 'package:donmexapp/controllers/user_controller.dart';
import 'package:donmexapp/data/repository/auth_repo.dart';
import 'package:donmexapp/data/repository/location_repo.dart';
import 'package:donmexapp/data/repository/order_repo.dart';
import 'package:donmexapp/data/repository/products_list_repo.dart';
import 'package:donmexapp/data/repository/spots_repo.dart';
import 'package:donmexapp/data/repository/user_repo.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/controllers/products_list_controller.dart';
import 'package:donmexapp/controllers/products_menu_controller.dart';
import 'package:donmexapp/data/api/api_client.dart';

import 'package:donmexapp/data/repository/cart_repo.dart';
import 'package:donmexapp/data/repository/products_menu_repo.dart';
import 'package:donmexapp/models/language_model.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  Get.lazyPut(() =>
      GoogleApiClient(googleBaseUrl: AppConstants.GOOGLE_BASE_URL, sharedPreferences: Get.find()));

  Get.lazyPut(() =>
      PosterApiClient(posterBaseUrl: AppConstants.POSTER_BASE_URL, sharedPreferences: Get.find()));

  // Get.lazyPut(
  //     () => PosterApiClient(BaseUrl: AppConstants.ADD_USER_ADDRESS, sharedPreferences: Get.find()));

  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductsListRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductsMenuRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationRepo(
      posterApiClient: Get.find(), googleApiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find()));
  Get.lazyPut(() => NavigationController());
  Get.lazyPut(() => SpotsRepo(apiClient: Get.find()));

//  Get.lazyPut(()=>AuthController(authRepo:Get.find(), clientsController: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => ProductsListController(productsListRepo: Get.find()));
  Get.lazyPut(() => ProductsMenuController(productsMenuRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => SpotsController(spotsRepo: Get.find()));

  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =
        await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();

    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }

  return _languages;
}

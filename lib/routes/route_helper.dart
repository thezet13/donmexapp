import 'package:donmexapp/pages/cart/order_processing_delivery_page.dart';
import 'package:donmexapp/pages/cart/order_processing_shop_page.dart';
import 'package:get/get.dart';
import 'package:donmexapp/pages/account/account_page.dart';
import 'package:donmexapp/pages/address/add_address_page.dart';
import 'package:donmexapp/pages/address/pick_address_map.dart';
import 'package:donmexapp/pages/auth/sign_in_page.dart';
import 'package:donmexapp/pages/auth/sign_up_page.dart';
import 'package:donmexapp/pages/cart/cart_history.dart';
import 'package:donmexapp/pages/cart/cart_order.dart';
import 'package:donmexapp/pages/map/map.dart';
import 'package:donmexapp/pages/splash/splash_page.dart';

import '../pages/cart/cart_page.dart';
import '../pages/food/food_detail.dart';
import '../pages/home/home_page.dart';
import '../pages/splash/language_page.dart';

class RouteHelper {
  static const String initial = "/";
  static const String splashPage = "/splashPage";
  static const String productMenuItem = "/product";
  static const String cartPage = "/cart-page";
  static const String orderHistory = "/order-history";
  static const String languagePage = "/language-page";
  static const String signupPage = "/signup-page";
  static const String signinPage = "/signin-page";
  static const String accountPage = "/account-page";
  static const String mapPage = "/map-page";
  static const String addAddress = "/add-address";
  static const String pickAddressMap = "/pick-address";
  static const String cartOrder = "/cart-order";
  static const String orderShopStatus = "/order-shop-status";
  static const String orderDeliveryStatus = "/order-delivery-status";

  static const String orderSuccess = "/order-successful";

  static String getSplashPage() => '$splashPage';
  static String getInitial() => '$initial';
  static String getProductMenuItem(int pageId, String page) =>
      '$productMenuItem?pageId=$pageId&page=$page';
  static String getCartPage() => '$cartPage';
  static String getOrderHistory() => '$orderHistory';
  static String getLanguage() => '$languagePage';
  static String getSignupPage() => '$signupPage';
  static String getSigninPage() => '$signinPage';
  static String getAccountPage() => '$accountPage';
  static String getMapPage() => '$mapPage';
  static String getAddressPage() => '$addAddress';
  static String getPickAddressPage() => '$pickAddressMap';
  static String getOrderSuccessPage() => '$orderSuccess';
  static String getCartOrderPage() => '$cartOrder';
  static String getOrderProcessingShopPage() => '$orderShopStatus';
  static String getOrderProcessingDeliveryPage() => '$orderDeliveryStatus';

  static List<GetPage> routes = [
    GetPage(
        name: pickAddressMap,
        page: () {
          PickAddressMap _pickAddress = Get.arguments;
          return _pickAddress;
        }),
    GetPage(name: splashPage, page: () => SplashScreen()),
    GetPage(name: initial, page: () => HomePage()),
    GetPage(name: languagePage, page: () => LanguagePage()),
    GetPage(name: signupPage, page: () => SignUpPage()),
    GetPage(name: signinPage, page: () => SignInPage()),
    GetPage(name: orderHistory, page: () => CartHistory()),
    //GetPage(name: accountPage, page: () => AccountPage()),
    GetPage(name: mapPage, page: () => MapPage()),
    GetPage(name: cartOrder, page: () => CartOrderPage()),
    GetPage(name: orderShopStatus, page: () => OrderProcessingShopPage()),
    GetPage(name: orderDeliveryStatus, page: () => OrderProcessingDeliveryPage()),

    GetPage(
        name: productMenuItem,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters["page"];
          return FoodDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn),

    GetPage(
      name: cartPage,
      page: () {
        return CartPage();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
        name: addAddress,
        page: () {
          return AddAddressPage();
        }),
    //  GetPage(name: orderSuccess, page: ()=>getOrderSuccessPage()))
  ];
}

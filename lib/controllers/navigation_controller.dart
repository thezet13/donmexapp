import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxString previousRoute = ''.obs;

  void setPreviousRoute(String route) {
    previousRoute.value = route;
  }
}
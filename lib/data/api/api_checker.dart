import 'package:donmexapp/base/show_custom_snackbar.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Get.offNamed(RouteHelper.getSigninPage());
    } else {
      showCustomSnackBar(response.statusText!);
    }
  }
}

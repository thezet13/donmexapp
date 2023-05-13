import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/base/show_custom_snackbar.dart';
import 'package:donmexapp/data/repository/auth_repo.dart';
import 'package:donmexapp/models/response_model.dart';
import 'package:donmexapp/models/signup_body_model.dart';
import 'package:donmexapp/routes/route_helper.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();

    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;

    if (response.body['error'] == 167) {
      print('phone exist');

      showCustomSnackBar("Phone already exist!", title: 'Sorry!');
      // print('response body 1'+response.body.toString());
      responseModel = ResponseModel(false, response.statusText!);
    } else if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(AppConstants.CLIENTID, response.body['response'].toString());

      await authRepo.saveClientId(response.body['response'].toString());
      responseModel = ResponseModel(true, response.body['response'].toString());

      await login(signUpBody.phone, signUpBody.password);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.getClientId(phone, password);
    late ResponseModel responseModel;

    var responseJson = jsonDecode(jsonEncode(response.body));
    if (responseJson['response'].isEmpty) {
      print('phone doesnt exist');
      showCustomSnackBar("Phone doesnt exist", title: 'Sorry!');
      responseModel = ResponseModel(false, response.statusText!);
    } else if (response.statusCode == 200) {
      print('after login:' + response.body.toString());

      var _clientId = responseJson['response'][0]['client_id'];
      var _password = responseJson['response'][0]['comment'];
      var _firstname = responseJson['response'][0]['firstname'];
      var _lastname = responseJson['response'][0]['lastname'];
      var _lat = responseJson['response'][0]['addresses'][0]['lat'];

      String _userAddress = jsonEncode(responseJson['response'][0]['addresses'][0]);

      SharedPreferences preferences = await SharedPreferences.getInstance();

      if (password == _password) {
        print('pass passed');

        preferences.setString('dm_clientId', _clientId);
        preferences.setString('dm_phone', phone);
        preferences.setString('dm_firstname', _firstname);
        preferences.setString('dm_lastname', _lastname);
        preferences.setString('dm_password', _password);
        preferences.setString('dm_lat', _lat);
        preferences.setString('dm_useraddress', _userAddress);

        responseModel = ResponseModel(true, response.statusText!);

        showCustomSnackBar("${_firstname} " "${_lastname} ", title: "welcome".tr);
        Get.offNamed(RouteHelper.getSplashPage());
      } else if (password != _password) {
        print('password is incorrect');

        showCustomSnackBar("Password is incorrect",
            title: 'Sorry!'); // do any other necessary action for empty response
        responseModel = ResponseModel(false, response.statusText!);
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // void saveClientsInfo(String phone, String lastname, String password) {
  //   authRepo.saveClientsInfo(phone, lastname, password);
  // }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/base/show_custom_snackbar.dart';
import 'package:donmexapp/models/response_model.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/widgets/app_text_field.dart';

class SignUpBody {
  late String client_name;
  late String phone;
  late String clientgroupsid;
  late String client_id;

  SignUpBody(
      {required this.client_name,
      required this.phone,
      required this.clientgroupsid,
      required this.client_id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["client_name"] = this.client_name;
    data["phone"] = this.phone;
    data["client_groups_id_client"] = this.clientgroupsid;
    data["client_id"] = this.client_id;
    return data;
  }
}

class AppConstants {
  static const String APP_NAME = "FoodApp";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "https://joinposter.com";
  static const String REGISTRATION_URI =
      "/api/clients.createClient?token=219854:311572788feec064b9960635fffa2fd6";

  static const String TOKEN = "";
}

class ApiClient extends GetConnect implements GetxService {
  late String? token;
  final String appBaseUrl;

  late Map<String, String> _mainHeaders;
  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    token = AppConstants.TOKEN;

    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(
    String uri,
  ) async {
    try {
      Response response = await get(uri);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });
  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  Future<String> getUserToken() async {
    return await sharedPreferences.getString(AppConstants.TOKEN) ?? "None";
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }
}

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
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"].toString());

      responseModel = ResponseModel(true, response.body["token"].toString());
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var nameController = TextEditingController();
    var clientgroupsidController = TextEditingController();
    var clientidController = TextEditingController();

    Future<void> _registration(AuthController authController) async {
      String client_name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String clientgroupsid = clientgroupsidController.text.trim();
      String client_id = clientidController.text.trim();

      if (client_name.isEmpty) {
        showCustomSnackBar("Type your name", title: "Name");
      } else if (phone.isEmpty) {
        showCustomSnackBar("Type your phone number", title: "Phone number");
      } else {
        //showCustomSnackBar("All went well", title: "Perfect");
        SignUpBody signUpBody = SignUpBody(
            client_name: client_name,
            phone: phone,
            clientgroupsid: clientgroupsid,
            client_id: client_id);

        authController.registration(signUpBody).then((status) {
          if (status.isSuccess) {
            print('The phone number is: ' + phone);
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      body: Stack(children: [
        Container(
          child: GestureDetector(
              onTap: () {},
              child: Container(
                child: Text(
                  'HOME',
                  style: TextStyle(fontSize: 50),
                ),
              )),
        ),
        Center(child: GetBuilder<AuthController>(
          builder: (_authController) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                      textController: nameController,
                      hintText: 'Name',
                      icon: Icons.person,
                      readOnly: false,
                      textColor: AppColors.colorWhite),
                  AppTextField(
                      textController: phoneController,
                      hintText: 'Phone',
                      icon: Icons.phone,
                      readOnly: false,
                      textColor: AppColors.colorWhite),
                  AppTextField(
                      textController: clientgroupsidController,
                      hintText: '1',
                      icon: Icons.circle,
                      readOnly: false,
                      textColor: AppColors.colorWhite),
                  GestureDetector(
                    onTap: () {
                      _registration(_authController);
                    },
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Text('Sign up'),
                    ),
                  ),
                ],
              ),
            );
          },
        )),
      ]),
    );
  }
}

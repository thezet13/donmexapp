import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/base/custom_loader.dart';
import 'package:donmexapp/base/show_custom_snackbar.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/app_text_field.dart';
import 'package:donmexapp/widgets/mid_text.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();

    void _getClientId(AuthController authController) async {
      String _phone = phoneController.text.trim();
      String _password = passwordController.text.trim();

      if (_phone.isEmpty) {
        showCustomSnackBar("Type your phone", title: "Phone");
      } else if (_password.isEmpty) {
        showCustomSnackBar("Type your password", title: "Password");
      } else {
        //SignUpBody signUpBody = SignUpBody(client_name: client_name, phone: phone, clientgroupsid: clientgroupsid, client_id: client_id, password: password);

        authController.login(_phone, _password).then((status) async {
          if (status.isSuccess) {
//print('SUCCESS ${loginStatus}');
            //Get.toNamed(RouteHelper.getInitial());
            // bool isPhoneExists = false; // Initialize a variable to keep track of whether the phone exists or not

            // Get.find<ClientsController>().clientsList.forEach((clients) async {
            //           if (phone == clients.phone!.replaceAll(' ', '')&&password == clients.password){
            //             SharedPreferences prefs = await SharedPreferences.getInstance();
            //             prefs.setString('phone', clients.phone!);
            //               print('fanta');
            //             }else{
            //                 print('sprite');
            //             }
            // });

            // if(isPhoneExists){
            // print('the phone is found');}
            //showCustomSnackBar("Welcome back, ${lastname}");
          } else {
//print('NOTSUCCESS ${loginStatus}');
            //showCustomSnackBar(status.message);
            //print('si means '+status.message);
          }
        });
      }
    }

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/donmex_wall.png"), fit: BoxFit.fill),
          ),
        ),
        Container(
          child: GestureDetector(
              onTap: () {
                Get.offNamed(RouteHelper.getInitial());
              },
              child: Container(
                child: Text(
                  'HOME',
                  style: TextStyle(fontSize: 50),
                ),
              )),
        ),
        Center(child: GetBuilder<AuthController>(
          builder: (_authController) {
            return !_authController.isLoading
                ? SingleChildScrollView(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Text(
                          "Sign in",
                          style: TextStyle(color: AppColors.colorGreen, fontSize: 32),
                        )),
                        SizedBox(height: Dimensions.h30),
                        AppTextField(
                            textController: phoneController,
                            hintText: 'Phone',
                            icon: Icons.phone,
                            readOnly: false,
                            textColor: AppColors.colorWhite),
                        AppTextField(
                            textController: passwordController,
                            hintText: 'Password',
                            readOnly: false,
                            textColor: AppColors.colorWhite,
                            icon: Icons.password),
                        GestureDetector(
                          onTap: () async {
                            _getClientId(_authController);
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Center(
                                child: MidText(
                              text: 'Sign in',
                              size: 24,
                              color: AppColors.colorGreen,
                            )),
                          ),
                        ),
                        SizedBox(height: Dimensions.h30),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.getSignupPage());
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Center(
                                child: MidText(
                              text: 'SIGN UP',
                              size: 24,
                              color: AppColors.colorGreen,
                            )),
                          ),
                        ),
                      ],
                    ),
                  )
                : CustomLoader();
          },
        )),
      ]),
    );
  }
}

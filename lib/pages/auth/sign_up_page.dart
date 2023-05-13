import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/base/custom_loader.dart';
import 'package:donmexapp/base/show_custom_snackbar.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/models/signup_body_model.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/app_text_field.dart';
import 'package:donmexapp/widgets/mid_text.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var nameController = TextEditingController();
    var clientgroupsidController = TextEditingController.fromValue(TextEditingValue(text: '1'));
    var clientidController = TextEditingController();
    var passwordController = TextEditingController();

    Future<void> _registration(AuthController authController) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String client_name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String clientgroupsid = clientgroupsidController.text.trim();
      String client_id = clientidController.text.trim();
      String password = passwordController.text.trim();

      // await Get.find<ClientsController>().getClients();
      // Get.find<ClientsController>().clientsList.forEach((clients) async {
      // });

      if (phone.isEmpty) {
        showCustomSnackBar("Type your phone", title: "Phone");
      } else if (client_name.isEmpty) {
        showCustomSnackBar("Type your name", title: "Name");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type your password", title: "Password");
      } else {
        SignUpBody signUpBody = SignUpBody(
          client_name: client_name,
          phone: phone,
          clientgroupsid: clientgroupsid,
          client_id: client_id,
          password: password,
        );

        authController.registration(signUpBody).then((status) async {
          if (status.isSuccess) {
            print('sign up success');
            print(sharedPreferences.getString(AppConstants.PHONE));
            Get.toNamed(RouteHelper.getInitial());
          } else {
            print('sign up unsuccess');
            //showCustomSnackBar("This phone number is already taken");
          }

          // bool isPhoneExists = false; // Initialize a variable to keep track of whether the phone exists or not

          // Get.find<ClientsController>().clientsList.forEach((clients) async {
          //           if (phone == clients.phone!.replaceAll(' ', '')){
          //               isPhoneExists = true; // Set the variable to true if the phone exists
          //           }else{
          //             Container(child: Text('ERROR!'));
          //             }
          //});

          //     if(isPhoneExists){
          //     print('Phone already exists in the clients list');}
          //     showCustomSnackBar("This phone number is already taken");
          // }else{
          //     print("where am I");
          // }
        }); //authController
      } //if during registration
    } //_registration

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
                Get.toNamed(RouteHelper.getInitial());
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
                          "Sign up",
                          style: TextStyle(color: AppColors.colorGreen, fontSize: 32),
                        )),
                        SizedBox(height: Dimensions.h30),

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
                            textController: passwordController,
                            hintText: 'Password',
                            icon: Icons.password,
                            readOnly: false,
                            textColor: AppColors.colorWhite),

                        Visibility(
                          visible: false,
                          child: AppTextField(
                              textController: clientgroupsidController,
                              hintText: '1',
                              icon: Icons.circle,
                              readOnly: true,
                              textColor: AppColors.colorWhite),
                        ),
                        GestureDetector(
                          onTap: () {
                            _registration(_authController);
                            //Get.toNamed(RouteHelper.cartPage);
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Center(
                                child: MidText(
                              text: 'Sign up',
                              size: 24,
                              color: AppColors.colorGreen,
                            )),
                          ),
                        ),

                        SizedBox(
                          height: Dimensions.h30,
                        ),

                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.signinPage);
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Center(
                                child: MidText(
                              text: 'or Sign in',
                              size: 24,
                              color: AppColors.colorGreen,
                            )),
                          ),
                        ),

//                       GestureDetector(
//                         onTap: (){
//                        print(_authController.authRepo.sharedPreferences.getString(AppConstants.PHONE));
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                           ),
//                           child: Center(child: MidText(text: 'what is my phone num?', size: 24, color: AppColors.colorGreen,)),
//                         ),
//                       ),
//                        GestureDetector(
//                         onTap: () async{
// print(_authController.authRepo.sharedPreferences.getString(AppConstants.CLIENTID));
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                           ),
//                           child: Center(child: MidText(text: 'what is my id?', size: 24, color: AppColors.colorGreen,)),
//                         ),
//                       ),
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

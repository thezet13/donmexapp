import 'package:donmexapp/pages/splash/language_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/base/custom_loader.dart';
import 'package:donmexapp/base/no_data_page.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/controllers/location_controller.dart';
import 'package:donmexapp/controllers/navigation_controller.dart';
import 'package:donmexapp/controllers/user_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/account_text.dart';
import 'package:donmexapp/widgets/account_widget.dart';
import 'package:donmexapp/widgets/account_button_widget.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback toMenuBody;
  const AccountPage({Key? key, required this.toMenuBody}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    final prefs = authController.authRepo.sharedPreferences;
    final _clientId = prefs.getString('dm_clientId') ?? '';

    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUserInfo(_clientId);
    }

    return Scaffold(
        backgroundColor: AppColors.colorBlack,
        body: GetBuilder<UserController>(builder: (userController) {
          return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/donmex_wall.png"),
                    fit: BoxFit.cover,
                    opacity: 0.4),
              ),
              child: _userLoggedIn
                  ? (userController.isLoading
                      ? Stack(children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(top: Dimensions.h20 * 2, right: Dimensions.w10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: Dimensions.w20 * 2.5),
                                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Padding(
                                        padding: EdgeInsets.only(top: Dimensions.h5),
                                        child: Text('title_account'.tr,
                                            style: TextStyle(
                                                fontSize: 28, color: AppColors.colorWhite))),
                                  ]),
                                  Column(
                                    children: [
                                      GestureDetector(
                                          onTap: widget.toMenuBody,
                                          child: Stack(children: [
                                            Positioned(
                                              child: Icon(Icons.lens_rounded,
                                                  size: 46, color: AppColors.colorBlack),
                                            ),
                                            Positioned(
                                              right: 9,
                                              top: 10,
                                              child: Icon(Icons.arrow_forward_ios_outlined,
                                                  size: 26, color: AppColors.colorGreen),
                                            ),
                                          ])),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: Dimensions.h30 * 3),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.h10, left: Dimensions.w20, right: Dimensions.w20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: Dimensions.h20),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        AccountWidget(
                                          icon: Icons.person,
                                          text: userController.userModel.lastname,
                                          onTap: () {
                                            Get.find<NavigationController>()
                                                .setPreviousRoute('AccountPage');
                                            Get.toNamed('');
                                          },
                                        ),
                                        SizedBox(
                                          height: Dimensions.h10,
                                        ),
                                        AccountWidget(
                                          icon: Icons.phone,
                                          text: userController.userModel.phone,
                                          onTap: () {
                                            Get.find<NavigationController>()
                                                .setPreviousRoute('AccountPage');
                                            Get.toNamed('');
                                          },
                                        ),
                                        SizedBox(
                                          height: Dimensions.h10,
                                        ),
                                        AccountWidget(
                                          icon: Icons.email,
                                          text: userController.userModel.email,
                                          onTap: () {
                                            Get.find<NavigationController>()
                                                .setPreviousRoute('AccountPage');
                                            Get.toNamed('');
                                          },
                                        ),
                                        SizedBox(
                                          height: Dimensions.h10,
                                        ),
                                        AccountWidget(
                                          icon: Icons.location_on,
                                          text: userController.userModel.address,
                                          onTap: () {
                                            Get.find<NavigationController>()
                                                .setPreviousRoute('AccountPage');
                                            Get.toNamed(RouteHelper.getAddressPage());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showLanguages(context, fromMenu: true);
                                      // showModalBottomSheet(
                                      //   context: context,
                                      //   isScrollControlled: false,
                                      //   backgroundColor: Colors.transparent,
                                      //   builder: (BuildContext context) => SizedBox(
                                      //     height: MediaQuery.of(context).size.height *
                                      //         0.5, // Customize height here (0.8 = 80%)
                                      //     child: const LanguagePage(fromMenu: true),
                                      //   ),
                                      //   shape: const RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.vertical(top: Radius.circular(20)),
                                      //   ),
                                      // );
                                    },
                                    child: AccountButtonWidget(
                                      icon: Icons.language,
                                      midText: AccountText(text: 'language'.tr),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.toNamed(RouteHelper.getLanguage());
                                  //   },
                                  //   child: AccountButtonWidget(
                                  //     icon: Icons.language,
                                  //     midText: AccountText(text: 'language'.tr),
                                  //   ),
                                  // ),
                                  SizedBox(height: Dimensions.h10),
                                  GestureDetector(
                                    onTap: () {
                                      Get.offNamed(RouteHelper.orderHistory);
                                    },
                                    child: AccountButtonWidget(
                                      icon: Icons.list,
                                      midText: AccountText(text: 'order_history'.tr),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.h10),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(RouteHelper.mapPage);
                                    },
                                    child: AccountButtonWidget(
                                      icon: Icons.password,
                                      midText: AccountText(text: 'change_password'.tr),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.h10),
                                  GestureDetector(
                                    onTap: () {
                                      if (Get.find<AuthController>().userLoggedIn()) {
                                        showLogoutConfirmation(context);
                                      }
                                    },
                                    child: AccountButtonWidget(
                                      icon: Icons.logout,
                                      midText: AccountText(text: 'logout'.tr),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.h30),
                                ],
                              ),
                            ),
                          ),
                        ])
                      : const CustomLoader())
                  : GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getSigninPage());
                      },
                      child: const NoDataPage(
                          text: 'You must log in', imgPath: "assets/images/donmex_empty.png")));
        }));
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.colorDarkGreen,
          title: const Text(
            'Donmex',
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
          content: Text(
            'want_to_logout'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes'.tr,
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              onPressed: () {
                // Perform logout actions here
                Get.find<AuthController>().clearSharedData();
                Get.find<CartController>().clear();
                Get.find<CartController>().clearCartHistory();
                Get.find<LocationController>().clearAddressList();
                Get.toNamed(RouteHelper.getSplashPage());

                // Close the confirmation dialog
                //Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                'No'.tr,
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              onPressed: () {
                // Close the confirmation dialog without performing any action
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showLanguages(BuildContext context, {required bool fromMenu}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.4,
            child: const LanguagePage(),
          ),
        );
      },
    );
  }
}

import 'package:donmexapp/base/show_error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/base/no_data_page.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/controllers/products_menu_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/mid_text.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<AuthController>().authRepo.sharedPreferences;
    final useraddress = prefs.getString('dm_useraddress');
    final serviceMode = prefs.getString('dm_serviceMode');
    return Scaffold(
        backgroundColor: AppColors.colorDarkGreen,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/donmex_wall.png"), fit: BoxFit.fill),
          ),
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).viewPadding.top,
                  width: MediaQuery.of(context).size.width,
                  child: SizedBox(height: MediaQuery.of(context).viewPadding.top)),
              Padding(
                  padding: EdgeInsets.only(
                    top: Dimensions.h5,
                    bottom: 0,
                  ),
                  child: Padding(
                      padding:
                          EdgeInsets.only(top: Dimensions.h20 * 2 + 2, left: Dimensions.w5 * 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteHelper.getInitial());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: Dimensions.w5 * 4,
                                      right: Dimensions.w5 * 2,
                                      top: Dimensions.h5 * 3,
                                      bottom: Dimensions.h5 * 3,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: Colors.black,
                                    ),
                                    child: Icon(Icons.arrow_back_ios,
                                        size: 22, color: AppColors.colorGreen),
                                  ))
                            ],
                          ),
                          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            GetBuilder<LocalizationController>(builder: (localizationController) {
                              return Padding(
                                  padding: EdgeInsets.only(top: Dimensions.h5),
                                  child: Text('title_cart'.tr,
                                      style: TextStyle(fontSize: 28, color: AppColors.colorWhite)));
                            }),
                          ]),
                          SizedBox(width: Dimensions.w20 * 2.5)
                        ],
                      ))),
              GetBuilder<CartController>(builder: (_cartController) {
                return _cartController.getItems.length > 0
                    ? Positioned(
                        top: Dimensions.h20 * 5,
                        left: Dimensions.w30,
                        right: Dimensions.w30,
                        bottom: 0,
                        child: Container(
                          margin: EdgeInsets.only(top: Dimensions.h20 * 3),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GetBuilder<CartController>(builder: (cartController) {
                              var _cartList = cartController.getItems;

                              return ListView.builder(
                                  itemCount: _cartList.length,
                                  itemBuilder: (_, index) {
                                    var selectedModifications =
                                        _cartList[index].modifications ?? [];
                                    var modificationNames =
                                        selectedModifications.map((e) => e['name']).toList();
                                    return Container(
                                      height: Dimensions.h20 * 5,
                                      width: double.maxFinite,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              var productIndex = Get.find<ProductsMenuController>()
                                                  .productsMenu
                                                  .indexOf(_cartList[index].product!);
                                              if (productIndex >= 0) {
                                                Get.toNamed(RouteHelper.getProductMenuItem(
                                                    productIndex, "cartpage"));
                                              } else {}
                                            },
                                            child: Container(
                                              width: Dimensions.h20 * 4,
                                              height: Dimensions.h20 * 3.5,
                                              //margin: EdgeInsets.only(bottom: Dimensions.h20),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        AppConstants.POSTER_BASE_URL +
                                                            cartController
                                                                .getItems[index].photoOrigin!,
                                                      )),
                                                  borderRadius:
                                                      BorderRadius.circular(Dimensions.r10)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimensions.w10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        cartController
                                                            .getItems[index].productName!.tr,
                                                        style: TextStyle(
                                                            color: AppColors.colorWhite,
                                                            fontSize: 16)),
                                                    SizedBox(width: Dimensions.h10),
                                                    Text(
                                                      (double.parse(cartController
                                                                      .getItems[index].price!.s1!) *
                                                                  0.01)
                                                              .toStringAsFixed(2) +
                                                          " ₼",
                                                      style: TextStyle(
                                                          color: AppColors.colorOrange,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(width: Dimensions.h10),
                                                    Text(
                                                        cartController.getItems[index].quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: AppColors.colorWhite,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                                if (selectedModifications.isNotEmpty) ...[
                                                  SizedBox(height: Dimensions.h10 / 2),
                                                  Container(
                                                    child: Text(modificationNames.join(', '),
                                                        style: TextStyle(
                                                            color: AppColors.colorGreen,
                                                            fontSize: 12)),
                                                  )
                                                ],
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: Dimensions.h10,
                                                bottom: Dimensions.h10,
                                                left: Dimensions.h20,
                                                right: Dimensions.h20),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(Dimensions.r20),
                                                topLeft: Radius.circular(Dimensions.r20),
                                                bottomRight: Radius.circular(Dimensions.r20),
                                                bottomLeft: Radius.circular(Dimensions.r20),
                                              ),
                                              color: AppColors.colorDisabledBMore,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    cartController.addItem(
                                                      _cartList[index].product!,
                                                      -1,
                                                      cartController.modificationsListToMap(
                                                          _cartList[index].modifications!),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: AppColors.colorGreen,
                                                  ),
                                                ),
                                                SizedBox(width: Dimensions.h10),
                                                MidText(
                                                  text: _cartList[index].quantity.toString(),
                                                ),
                                                SizedBox(width: Dimensions.h10),
                                                GestureDetector(
                                                  onTap: () {
                                                    cartController.addItem(
                                                      _cartList[index].product!,
                                                      1,
                                                      cartController.modificationsListToMap(
                                                          _cartList[index].modifications!),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    color: AppColors.colorGreen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }),
                          ),
                        ))
                    : GetBuilder<LocalizationController>(builder: (localizationController) {
                        return NoDataPage(text: 'status_empty'.tr);
                      });
              }),
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (controller) {
            return controller.getItems.length > 0
                ? Container(
                    padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                    margin: const EdgeInsets.only(left: 0, right: 0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      color: Color.fromARGB(255, 0, 120, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.h5 * 5,
                              bottom: Dimensions.h5 * 5,
                              left: Dimensions.h5 * 5,
                              right: Dimensions.h5 * 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.r20),
                              topLeft: Radius.circular(Dimensions.r20),
                              bottomRight: Radius.circular(Dimensions.r20),
                              bottomLeft: Radius.circular(Dimensions.r20),
                            ),
                            color: AppColors.colorDisabledB,
                          ),
                          child: Row(
                            children: [
                              MidText(text: controller.totalAmount.toStringAsFixed(2) + " ₼"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (Get.find<AuthController>().userLoggedIn()) {
                              if (serviceMode != null) {
                                if (useraddress!.isNotEmpty) {
                                  Get.toNamed(RouteHelper.getCartOrderPage());
                                } else {
                                  print('nope');
                                }
                              } else {
                                showErrorSnackBar('Please choose delivery type');
                              }
                            } else {
                              Get.toNamed(RouteHelper.getSigninPage());
                            }
                            //productsMenu. addItem(product);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: Dimensions.h5 * 5,
                                bottom: Dimensions.h5 * 5,
                                left: Dimensions.h30,
                                right: Dimensions.h30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.r20),
                                topLeft: Radius.circular(Dimensions.r20),
                                bottomRight: Radius.circular(Dimensions.r20),
                                bottomLeft: Radius.circular(Dimensions.r20),
                              ),
                              color: AppColors.colorBlack,
                            ),
                            child: Row(
                              children: [
                                GetBuilder<LocalizationController>(
                                    builder: (localizationController) {
                                  return MidText(
                                      text: 'button_checkout'.tr, color: AppColors.colorGreen);
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
                : Container(
                    height: 0,
                  );
          },
        ));
  }
}

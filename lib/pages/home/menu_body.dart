import 'package:donmexapp/base/custom_loader.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/pages/splash/language_page.dart';
import 'package:donmexapp/widgets/mid_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/controllers/products_menu_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/bottom_sheet_widget.dart';
import 'package:donmexapp/widgets/categories_with_products.dart';
import 'package:donmexapp/widgets/spots_sheet.dart';
import 'package:donmexapp/widgets/top_bar_status.dart';
import 'package:donmexapp/models/spots_model.dart';

class MenuBody extends StatefulWidget {
  final VoidCallback toAccountPage;
  final Function(String) onSpotSelected;

  MenuBody({Key? key, required this.toAccountPage, required this.onSpotSelected}) : super(key: key);

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  final GlobalKey<TopBarStatusState> topBarStatusKey = GlobalKey<TopBarStatusState>();
  List<Spot> spots = [];

  Future<void> saveSelectedOption(String option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dm_serviceMode', option);
  }

  get height => null;
  PageController pageController = PageController(viewportFraction: 0.95);

  String? _serviceMode;

  Future<void> _loadServiceMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _serviceMode = prefs.getString('dm_serviceMode');
    });
  }

  @override
  void initState() {
    super.initState();

    _loadServiceMode();

    _serviceMode = Get.find<SharedPreferences>().getString('dm_serviceMode');
    if (_serviceMode == null || _serviceMode!.isEmpty) {
      showBottomSheetWidget();
    } else {
      print('service mode: ' + _serviceMode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();

    return Stack(children: [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: MediaQuery.of(context).viewPadding.top + 5,
                width: MediaQuery.of(context).size.width,
                child: SizedBox(height: MediaQuery.of(context).viewPadding.top)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _userLoggedIn
                  ? GestureDetector(
                      onTap: widget.toAccountPage,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: Dimensions.w5 * 3,
                          right: Dimensions.w5 * 3.7,
                          top: Dimensions.h5 * 3.7,
                          bottom: Dimensions.h5 * 3.7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: AppColors.colorDarkestGreen,
                        ),
                        child: Icon(Icons.person, size: 32, color: AppColors.colorGreen),
                      ))
                  : GestureDetector(
                      onTap: () => showLanguages(context, fromMenu: true),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: Dimensions.w5 * 3,
                          right: Dimensions.w5 * 3.7,
                          top: Dimensions.h5 * 3.7,
                          bottom: Dimensions.h5 * 3.7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: AppColors.colorDarkestGreen,
                        ),
                        child: Icon(Icons.language, size: 32, color: AppColors.colorGreen),
                      )),

              //
              GestureDetector(
                onTap: () {
                  openOptionsBottomSheet();
                },
                child: Container(
                  width: Dimensions.w20 * 11,
                  height: Dimensions.w5 * 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: AppColors.colorBlack,
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: Dimensions.w20,
                        right: Dimensions.w20,
                        top: Dimensions.h10,
                        bottom: Dimensions.h5 * 3,
                      ),
                      child: TopBarStatus(key: topBarStatusKey)),
                ),
              ),
              GetBuilder<ProductsMenuController>(builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    if (controller.totalItems >= 1) Get.toNamed(RouteHelper.getCartPage());
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: Dimensions.w5 * 3,
                      right: Dimensions.w5 * 3,
                      top: Dimensions.h5 * 3,
                      bottom: Dimensions.h5 * 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      color: AppColors.colorDarkestGreen,
                    ),
                    child: Stack(children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 42,
                        color: AppColors.colorOrange,
                      ),
                      controller.totalItems >= 1
                          ? Positioned(
                              left: 0,
                              top: 0,
                              child: Icon(Icons.circle, size: 32, color: AppColors.colorOrange))
                          : //empty cart
                          Container(),
                      controller.totalItems >= 1
                          ? Positioned(
                              left: 10,
                              top: 5,
                              child: Text(Get.find<ProductsMenuController>().totalItems.toString(),
                                  style: TextStyle(fontSize: 18, color: AppColors.colorWhite)))
                          : //empty cart
                          Container(),
                    ]),
                  ),
                );
              })
            ]),
            SizedBox(height: 30),
            GetBuilder<ProductsMenuController>(builder: (theProduct) {
              return theProduct.isLoaded
                  ? Column(
                      children: [
                        CategoryWithProducts(categoryName: 'Burritos'),
                        CategoryWithProducts(categoryName: 'Bowls'),
                      ],
                    )
                  : Center(child: CustomLoader());
            }),
          ],
        ),
      ),
      Get.find<ProductsMenuController>().totalItems >= 1
          ? Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                margin: EdgeInsets.only(left: 0, right: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: AppColors.colorDisabledBMore2,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (_serviceMode == null || _serviceMode!.isEmpty) {
                      openOptionsBottomSheet();
                    } else {
                      Get.toNamed(RouteHelper.getCartOrderPage());
                    }
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
                      color: AppColors.colorOrange,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MidText(text: 'cart'.tr, color: AppColors.colorWhite),
                        MidText(
                          text: Get.find<CartController>().totalAmount.toStringAsFixed(2) + " ₼",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container()
    ]);
  }

  void showBottomSheetWidget() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => BottomSheetWidget(
          onOptionSelected: (option) {
            topBarStatusKey.currentState!.updateServiceMode(option);
          },
          showSpotsBottomSheet: showSpotsBottomSheet,
        ),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      );
    });
  }

  void openOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => BottomSheetWidget(
        onOptionSelected: (option) {
          topBarStatusKey.currentState!.updateServiceMode(option);
        },
        showSpotsBottomSheet: showSpotsBottomSheet,
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void showSpotsBottomSheet(String option) {
    print('Selected option: $option');
    if (option == '1' || option == '2') {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return SpotSelectionBottomSheet(
            onSpotSelected: (spot_name) {
              topBarStatusKey.currentState!.updateSpotName(spot_name);
              widget.onSpotSelected(spot_name);
            },
          );
        },
      );
    }
  }

// ignore: unused_element
  Widget _buildPageItem(int index, productsList) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.getProductMenuItem(index, "home"));
          },
          child: Container(
            height: 250,
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(AppConstants.POSTER_BASE_URL + productsList.photoOrigin!),
              ),
            ),
          ),
        ),
      ],
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

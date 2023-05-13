import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/controllers/products_menu_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/mid_text.dart';
import 'package:donmexapp/app_constants.dart';

class RoundedCheckboxBorder extends RoundedRectangleBorder {
  const RoundedCheckboxBorder({
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    side = BorderSide.none,
  }) : super(side: side);
  final BorderRadiusGeometry borderRadius;
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final RRect rrect = borderRadius.resolve(textDirection).toRRect(rect);
    return Path()..addRRect(rrect);
  }
}

class FoodDetail extends StatelessWidget {
  final int pageId;
  final String page;
  const FoodDetail({Key? key, required this.pageId, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Get.find<ProductsMenuController>().productsMenu[pageId];
    final _uiPrice = (double.parse(product.price!.s1!) * 0.01).toStringAsFixed(2);
    final Map<int, bool> _selectedModifications = {};

    Get.find<ProductsMenuController>()
        .initProduct(product, Get.find<CartController>(), quantity: 1);

    return Scaffold(
        backgroundColor: AppColors.colorDarkGreen,
        body: Stack(
          children: [
            Container(
              color: AppColors.colorGreen,
              height: MediaQuery.of(context).size.height / 1.85,
              child: Image.network(
                AppConstants.POSTER_BASE_URL + product.photoOrigin!,
                fit: BoxFit.cover,
              ),
            ),

            // Overlapping layer
            CustomScrollView(
              slivers: [
                GetBuilder<ProductsMenuController>(builder: (productsMenu) {
                  return SliverPadding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2, // Adjust the overlap value here
                    ),
                    sliver: SliverToBoxAdapter(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/donmex_wall.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Add your own widgets here
                              const SizedBox(height: 15),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.w30,
                                    top: Dimensions.h10,
                                    right: 0,
                                    bottom: Dimensions.h5),
                                child: Text(product.productName!.tr,
                                    style: TextStyle(color: AppColors.colorWhite, fontSize: 36)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.w30, top: 0, right: Dimensions.w10, bottom: 0),
                                child: Text(
                                  product.ingredients != null
                                      ? product.ingredients!
                                          .map((ingredient) => ingredient.ingredientName?.tr ?? '')
                                          .where((name) => name.isNotEmpty)
                                          .join(', ')
                                      : '',
                                  style: TextStyle(color: AppColors.colorGreen, fontSize: 16),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.w30,
                                    top: Dimensions.h10,
                                    right: Dimensions.w20,
                                    bottom: 0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _uiPrice + ' ₼',
                                    style: TextStyle(
                                        color: AppColors.colorOrange, fontSize: Dimensions.h30),
                                  ),
                                ),
                              ),

                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: product.groupModifications?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  final group = product.groupModifications![index];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: Dimensions.w30,
                                            top: 0,
                                            right: 0,
                                            bottom: Dimensions.h10),
                                        child: Text(
                                          group.name!.tr,
                                          style:
                                              TextStyle(fontSize: 18, color: AppColors.colorGreen),
                                        ),
                                      ),
                                      productsMenu.quantity > 0
                                          ? ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: group.modifications?.length ?? 0,
                                              itemExtent: 33,
                                              itemBuilder: (BuildContext context, int index) {
                                                final modification = group.modifications![index];
                                                int uniqueIndex =
                                                    group.dishModificationGroupId! * 1000 + index;
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Dimensions.w5 * 3,
                                                      right: Dimensions.w5 * 6),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Transform.scale(
                                                        scale: 1.2,
                                                        child: Checkbox(
                                                          checkColor: AppColors.colorWhite,
                                                          side: BorderSide(
                                                              color: AppColors.colorGreen,
                                                              width: 1),
                                                          activeColor: AppColors.colorGreen,
                                                          value:
                                                              _selectedModifications[uniqueIndex] ??
                                                                  false,
                                                          onChanged: (bool? value) {
                                                            _selectedModifications[uniqueIndex] =
                                                                value!;
                                                            productsMenu.updateProductPrice(
                                                                product, _selectedModifications);
                                                          },
                                                          shape: const RoundedCheckboxBorder(),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              modification.name!.tr,
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              '+' +
                                                                  double.parse(modification.price
                                                                          .toString())
                                                                      .toStringAsFixed(2) +
                                                                  ' ₼',
                                                              style: TextStyle(
                                                                  color: AppColors.colorOrange,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: group.modifications?.length ?? 0,
                                              itemExtent: 33,
                                              itemBuilder: (BuildContext context, int index) {
                                                final modification = group.modifications![index];
                                                int uniqueIndex =
                                                    group.dishModificationGroupId! * 1000 + index;
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Dimensions.w5 * 3,
                                                      right: Dimensions.w5 * 6),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Transform.scale(
                                                        scale: 1.2,
                                                        child: Checkbox(
                                                          checkColor: AppColors.colorWhite,
                                                          side: BorderSide(
                                                              color: AppColors.colorDisabledW,
                                                              width: 1),
                                                          activeColor: AppColors.colorDisabledW,
                                                          value:
                                                              _selectedModifications[uniqueIndex] ??
                                                                  false,
                                                          onChanged: (bool? value) {
                                                            null;
                                                          },
                                                          shape: const RoundedCheckboxBorder(),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              modification.name!.tr,
                                                              style: TextStyle(
                                                                  color: AppColors.colorDisabledW,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              '+' +
                                                                  double.parse(modification.price
                                                                          .toString())
                                                                      .toStringAsFixed(2) +
                                                                  ' ₼',
                                                              style: TextStyle(
                                                                  color: AppColors.colorDisabledW,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: Dimensions.h30 * 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),

            Stack(children: [
              Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top + Dimensions.h10,
                    left: Dimensions.w5 * 3,
                    bottom: 0,
                  ),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Padding(
                            padding: const EdgeInsets.only(),
                            child: GetBuilder<ProductsMenuController>(builder: (controller) {
                              return GestureDetector(
                                  onTap: () {
                                    print('tap');
                                    Get.toNamed(RouteHelper.getInitial());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: Dimensions.w5 * 4,
                                      right: Dimensions.w5 * 2,
                                      top: Dimensions.h5 * 3,
                                      bottom: Dimensions.h5 * 3,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: AppColors.colorBlack,
                                    ),
                                    child: Icon(Icons.arrow_back_ios,
                                        size: 22, color: AppColors.colorGreen),
                                  ));
                            })),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                            right: Dimensions.w5,
                          ),
                          child: GetBuilder<ProductsMenuController>(builder: (controller) {
                            return GestureDetector(
                              onTap: () {
                                if (controller.totalItems >= 1) {
                                  Get.toNamed(RouteHelper.getCartPage());
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: Dimensions.w10,
                                  right: Dimensions.w10,
                                  top: Dimensions.h10,
                                  bottom: Dimensions.h10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: AppColors.colorDarkGreen,
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
                                          child: Icon(Icons.circle,
                                              size: 32, color: AppColors.colorOrange))
                                      : //empty cart
                                      Container(),
                                  controller.totalItems >= 1
                                      ? Positioned(
                                          left: 10,
                                          top: 5,
                                          child: Text(
                                              Get.find<ProductsMenuController>()
                                                  .totalItems
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18, color: AppColors.colorWhite)))
                                      : //empty cart
                                      Container(),
                                ]),
                              ),
                            );
                          }),
                        )
                      ]),
                    ],
                  ))
            ]),
          ],
        ),
        bottomNavigationBar: GetBuilder<ProductsMenuController>(
          builder: (productsMenu) {
            return Container(
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
                        left: Dimensions.h20,
                        right: Dimensions.h20),
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
                        GestureDetector(
                            onTap: () {
                              productsMenu.setQuantity(false);
                            },
                            child: Icon(
                              Icons.remove,
                              color: AppColors.colorGreen,
                            )),
                        SizedBox(width: Dimensions.h10),
                        MidText(text: productsMenu.inCartItems.toString()),
                        SizedBox(width: Dimensions.h10),
                        GestureDetector(
                            onTap: () {
                              productsMenu.setQuantity(true);
                            },
                            child: Icon(
                              Icons.add,
                              color: AppColors.colorGreen,
                            )),
                      ],
                    ),
                  ),
                  productsMenu.quantity > 0
                      ? GestureDetector(
                          onTap: () {
                            productsMenu.addItem(product, _selectedModifications);
                            Get.toNamed(RouteHelper.getInitial());
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
                              children: [
                                Text(
                                  productsMenu.quantity > 0
                                      ? '${double.parse(productsMenu.getTotalPriceTwo(product, productsMenu, _selectedModifications)).toStringAsFixed(2)} ₼'
                                      : '0 ₼',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.colorWhite,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: '',
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: Dimensions.w10,
                                ),
                                MidText(text: 'button_add'.tr, color: AppColors.colorWhite)
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          // onTap:(){
                          //   Get.snackbar("Donmex", "Hey! Nothing to add!",
                          //   backgroundColor:  Color.fromARGB(255, 0, 120, 50),
                          //   colorText: AppColors.colorWhite,
                          //   );
                          // },
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
                              color: AppColors.colorDisabledB,
                            ),
                            child: Row(
                              children: [
                                MidText(
                                    text: 'button_add'.tr,
                                    color: Color.fromRGBO(255, 255, 255, 0.3))
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ));
  }
}

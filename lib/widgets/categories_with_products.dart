import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/controllers/products_menu_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class CategoryWithProducts extends StatelessWidget {
  final String categoryName;

  CategoryWithProducts({Key? key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsMenuController>(builder: (theProduct) {
      final filteredProducts =
          theProduct.productsMenu.where((product) => product.categoryName == categoryName).toList();

      return theProduct.isLoaded
          ? Padding(
              padding: EdgeInsets.only(bottom: Dimensions.h20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Dimensions.w30, top: Dimensions.h10, bottom: Dimensions.h5 * 5),
                    child: GetBuilder<LocalizationController>(builder: (localizationController) {
                      return Text(
                        categoryName.tr,
                        style: TextStyle(fontSize: 36, color: AppColors.colorWhite),
                        textAlign: TextAlign.start,
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 0),
                    child: GridView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: Dimensions.h20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: Dimensions.h20,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              int originalIndex =
                                  theProduct.productsMenu.indexOf(filteredProducts[i]);
                              Get.toNamed(RouteHelper.getProductMenuItem(originalIndex, "home"));
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    color: AppColors.colorDisabledBMore,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Dimensions.w20 * 8,
                                      height: Dimensions.h20 * 8,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(0),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(0),
                                          ),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(AppConstants.POSTER_BASE_URL +
                                                  filteredProducts[i].photoOrigin!))),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          top: Dimensions.h5 * 3,
                                          left: Dimensions.w20,
                                        ),
                                        child: GetBuilder<LocalizationController>(
                                            builder: (localizationController) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(filteredProducts[i].productName!.tr,
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: AppColors.colorWhite,
                                                      fontWeight: FontWeight.w400)),
                                              Text(
                                                  (double.parse(filteredProducts[i].price!.s1!) *
                                                              0.01)
                                                          .toStringAsFixed(2) +
                                                      " ₼",
                                                  style: TextStyle(
                                                      color: AppColors.colorOrange,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w400)),
                                            ],
                                          );
                                        })),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          : CircularProgressIndicator(color: AppColors.colorDarkGreen);
    });
  }
}

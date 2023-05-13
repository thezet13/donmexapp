import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/controllers/products_menu_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/widgets/categories_with_products.dart';
import '../../app_constants.dart';

class MenuBody extends StatefulWidget {
  final VoidCallback toAccountPage;

  MenuBody({Key? key, required this.toAccountPage}) : super(key: key);

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  PageController pageController = PageController(viewportFraction: 0.95);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Responsive padding based on screen width
    EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: screenWidth * 0.03,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            Padding(
              padding: EdgeInsets.only(
                top: screenWidth * 0.025,
                bottom: 0,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GetBuilder<ProductsMenuController>(builder: (controller) {
                  return GestureDetector(
                      onTap: widget.toAccountPage,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.025),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: AppColors.colorDarkestGreen,
                        ),
                        child: Icon(Icons.person,
                            size: screenWidth * 0.08, color: AppColors.colorGreen),
                      ));
                }),
                //
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    padding: EdgeInsets.all(screenWidth * 0.025),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.colorBlack,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'В заведении',
                          style:
                              TextStyle(color: AppColors.colorWhite, fontSize: screenWidth * 0.045),
                        ),
                        SizedBox(height: screenWidth * 0.025),
                        Text('ул. Б. Нуриева 24, Baku, Azerbaijan',
                            style: TextStyle(
                                color: AppColors.colorGreen, fontSize: screenWidth * 0.045),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
                GetBuilder<ProductsMenuController>(builder: (controller) {
                  return GestureDetector(
                    onTap: () {
                      if (controller.totalItems >= 1) Get.toNamed(RouteHelper.getCartPage());
                    },
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.025),
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
                          size: screenWidth * 0.1,
                          color: AppColors.colorOrange,
                        ),
                        controller.totalItems >= 1
                            ? Positioned(
                                left: 0,
                                top: 0,
                                child: Icon(Icons.circle,
                                    size: screenWidth * 0.08, color: AppColors.colorOrange))
                            : //empty cart
                            Container(),
                        controller.totalItems >= 1
                            ? Positioned(
                                left: screenWidth * 0.025,
                                top: screenWidth * 0.0125,
                                child: Text(
                                    Get.find<ProductsMenuController>().totalItems.toString(),
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        color: AppColors.colorWhite)))
                            : //empty cart
                            Container(),
                      ]),
                    ),
                  );
                })
              ]),
            ),
            SizedBox(height: screenWidth * 0.075),
            GetBuilder<ProductsMenuController>(builder: (theProduct) {
              return theProduct.isLoaded
                  ? Column(
                      children: [
                        CategoryWithProducts(categoryName: 'Burritos'),
                        CategoryWithProducts(categoryName: 'Bowls'),
                      ],
                    )
                  : Center(child: CircularProgressIndicator(color: AppColors.colorDarkGreen));
            }),
          ],
        ),
      ),
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
          margin: EdgeInsets.symmetric(horizontal: 5),
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

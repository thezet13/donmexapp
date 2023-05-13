import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/base/no_data_page.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList = Get.find<CartController>().getCartHistoryList().reversed.toList();

    Map<String, dynamic> cartItemsPerOrder = Map();

    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(getCartHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<dynamic> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<dynamic> itemsPerOrder = cartOrderTimeToList();

    var listCounter = 0;

    return Scaffold(
      //backgroundColor: AppColors.colorWhite,
      body: Container(
        decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage("assets/images/donmex_wall.png"), fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            // Container(
            //   //color: AppColors.colorDarkGreen,
            //   width: double.maxFinite,
            //   padding: EdgeInsets.only(top:Dimensions.h20*2.5,left:Dimensions.w20,bottom:Dimensions.w20),
            //   child: Row(children: [
            //     Text("Orders history", textAlign: TextAlign.center, style: TextStyle(color: AppColors.colorWhite, fontSize: 22) )
            //   ]),
            // ),

            Container(
                padding: EdgeInsets.only(
                    top: Dimensions.h20 * 2.5, left: Dimensions.w20, bottom: Dimensions.w20),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.getAccountPage());
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              child: Icon(Icons.lens_rounded,
                                  size: 46, color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            Positioned(
                              left: 9,
                              top: 10,
                              child: Icon(Icons.arrow_back_outlined,
                                  size: 26, color: AppColors.colorGreen),
                            ),
                          ],
                        )),
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                          //padding:EdgeInsets.only(left:30),
                          child:
                              GetBuilder<LocalizationController>(builder: (localizationController) {
                        return Text('title_history'.tr,
                            style: TextStyle(fontSize: 28, color: AppColors.colorWhite));
                      })),
                    ]),
                    Column(children: [Text('')]),
                  ],
                )),
            GetBuilder<CartController>(builder: (_cartController) {
              return _cartController.getCartHistoryList().length > 0
                  ? Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: Dimensions.h20, left: Dimensions.w20, right: Dimensions.w20),
                        child: MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView(
                              children: [
                                for (int i = 0; i < itemsPerOrder.length; i++)
                                  Container(
                                    height: Dimensions.h30 * 5,
                                    margin: EdgeInsets.only(bottom: Dimensions.h20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //Text(getCartHistoryList[listCounter].time!),
                                        //((){
                                        //DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(getCartHistoryList[listCounter].time!);
                                        //var inputDate = DateTime.parse(parseDate.toString());
                                        //var outputFormat = DateFormat("EEE, MMM d, yy | HH:MM");
                                        //var outputDate = outputFormat.format(inputDate);
                                        //return Text(outputDate);
                                        //}()),
                                        SizedBox(height: Dimensions.h10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Wrap(
                                              direction: Axis.horizontal,
                                              children: List.generate(itemsPerOrder[i], (index) {
                                                if (listCounter < getCartHistoryList.length) {
                                                  listCounter++;
                                                }
                                                return index <= 5
                                                    ? Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: Dimensions.h30 * 3,
                                                              width: Dimensions.h30 * 3,
                                                              margin: EdgeInsets.only(
                                                                  right: Dimensions.w10 / 2),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius
                                                                      .circular(Dimensions.r10),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit.cover,
                                                                      image: NetworkImage(
                                                                          AppConstants
                                                                                  .POSTER_BASE_URL +
                                                                              getCartHistoryList[
                                                                                      listCounter -
                                                                                          1]
                                                                                  .photoOrigin!))),
                                                            ),
                                                            Container(
                                                              child: Text(getCartHistoryList[
                                                                      listCounter - 1]
                                                                  .productName!),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Container();
                                              }),
                                            ),
                                            Container()

                                            //   Container(
                                            //     height: 90,
                                            //     child: Column(
                                            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //       crossAxisAlignment: CrossAxisAlignment.start,
                                            //       children: [
                                            //         Text("Total"),
                                            //         Text(itemsPerOrder[i].toString()+" items"),
                                            //         Container(
                                            //           padding: EdgeInsets.all(Dimensions.h10/1.5),
                                            //           decoration: BoxDecoration(
                                            //             borderRadius: BorderRadius.circular(Dimensions.h10),
                                            //             border: Border.all(width: 1, color:AppColors.colorDarkGreen),

                                            //           ),
                                            //           child: Text("order"),
                                            //         )
                                            //       ],
                                            //     ),
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            )),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 104),
                      child: NoDataPage(
                          text: "You didn't order anything!",
                          imgPath: "assets/images/donmex_empty.png"));
            })
          ],
        ),
      ),
    );
  }
}

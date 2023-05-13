import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage("assets/images/donmex_wall.png"), fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(
                    top: Dimensions.h20 * 2.5, left: Dimensions.w20, bottom: Dimensions.w20),
                child: Row(
                  children: [
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(child:
                          GetBuilder<LocalizationController>(builder: (localizationController) {
                        return Text('Blank'.tr,
                            style: TextStyle(fontSize: 28, color: AppColors.colorWhite));
                      }))
                    ]),
                  ],
                )),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.h20, left: Dimensions.w20, right: Dimensions.w20),
                child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
                      children: [Container()],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/language_controller.dart';
import 'language_widget.dart';

class LanguagePage extends StatelessWidget {
  final bool fromMenu;
  const LanguagePage({super.key, this.fromMenu = false});

  @override
  Widget build(BuildContext context) {
    double? width = Dimensions.w30 * 10;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorDarkGreen3,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: GetBuilder<LocalizationController>(builder: (localizationController) {
        return Column(children: [
          Expanded(
              child: Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(5),
                child: Center(
                    child: SizedBox(
                  width: width,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Dimensions.r10),
                          child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 3,
                              ),
                              itemCount: 3, //localizationController.languages.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => LanguageWidget(
                                    languageModel: localizationController.languages[index],
                                    localizationController: localizationController,
                                    index: index,
                                    fromMenu: fromMenu,
                                  )),
                        ),

                        //Text('save'.tr, ),
                      ]),
                )),
              ),
            ),
          )),
          // ElevatedButton(
          //   child: Text('save_button'.tr),
          //   onPressed: () {
          //     if (localizationController.languages.isNotEmpty &&
          //         localizationController.selectedIndex != -1) {
          //       localizationController.setLanguage(Locale(
          //         AppConstants.languages[localizationController.selectedIndex].languageCode,
          //         AppConstants.languages[localizationController.selectedIndex].countryCode,
          //       ));
          //       if (fromMenu) {
          //         Navigator.pop(context);
          //       } else {
          //         //Get.snackbar('save'.tr, 'select_language'.tr);
          //         //Get.offNamed(RouteHelper.initial);
          //         Get.offNamed(RouteHelper.getAccountPage());
          //         print(
          //             AppConstants.languages[localizationController.selectedIndex].languageCode);
          //       }
          //     } else {
          //       Get.snackbar('save'.tr, 'select_language'.tr);
          //     }
          //   },
          // ),
        ]);
      }),
    );
  }
}

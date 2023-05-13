import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:flutter/material.dart';

import '../../app_constants.dart';
import '../../controllers/language_controller.dart';
import '../../models/language_model.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  final bool fromMenu;
  const LanguageWidget(
      {super.key,
      required this.languageModel,
      required this.localizationController,
      required this.index,
      required this.fromMenu});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
        if (!fromMenu) {
          Navigator.pop(context);
        }
      },
      child: Container(
        //padding: EdgeInsets.all(Dimensions.h10),
        margin: EdgeInsets.all(Dimensions.h5),
        decoration: BoxDecoration(
          color: localizationController.selectedIndex == index
              ? AppColors.colorDarkGreen2
              : AppColors.colorDarkGreen,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(width: 1, color: AppColors.colorDisabledG),
        ),
        child: Stack(children: [
          Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageModel.languageName,
                    style: localizationController.selectedIndex == index
                        ? TextStyle(color: AppColors.colorWhite, fontSize: 20)
                        : TextStyle(color: AppColors.colorGreen, fontSize: 20),
                  ),
                ]),
          ),
          // localizationController.selectedIndex == index
          //     ? SizedBox(
          //         child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 25),
          //       )
          //     : const Icon(Icons.circle, color: Colors.grey, size: 25),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/widgets/mid_text.dart';

void showErrorSnackBar(String message, {bool isError = true, String title = "Error"}) {
  Get.snackbar(
    title,
    message,
    titleText: MidText(text: title, color: AppColors.colorWhite),
    messageText: Text(
      message,
      style: TextStyle(color: AppColors.colorWhite, fontSize: 18),
    ),
    colorText: AppColors.colorWhite,
    snackPosition: SnackPosition.TOP,
    backgroundColor: AppColors.colorRed,
  );
}

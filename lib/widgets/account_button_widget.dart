import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/account_text.dart';
import 'package:donmexapp/widgets/app_icon.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountButtonWidget extends StatelessWidget {
  IconData icon;
  AccountText midText;

  AccountButtonWidget({Key? key, required this.icon, required this.midText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Dimensions.w10, top: Dimensions.h10, bottom: Dimensions.h10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.colorDisabledG),
        color: AppColors.colorDisabledG,
      ),
      child: Row(
        children: [
          AppIcon(
            icon: icon,
            iconColor: AppColors.colorGreen,
            backgroundColor: Colors.transparent,
            size: 35,
            iconSize: 20,
          ),
          SizedBox(width: Dimensions.w10),
          midText,
        ],
      ),
    );
  }
}

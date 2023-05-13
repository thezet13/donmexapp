import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/account_text.dart';
import 'package:donmexapp/widgets/app_icon.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountWidget extends StatelessWidget {
  IconData icon;
  String text;
  final VoidCallback? onTap;
  AccountWidget({Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Dimensions.w10, top: Dimensions.h10, bottom: Dimensions.h10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.colorDisabledG),
        color: AppColors.colorDisabledBMore2,
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
          AccountText(text: text),
          // SizedBox(
          //   width: Dimensions.w10 * 4,
          //   child: GestureDetector(
          //     onTap: onTap,
          //     child: Icon(Icons.edit, color: AppColors.colorGreen),
          //   ),
          // ),
        ],
      ),
    );
  }
}

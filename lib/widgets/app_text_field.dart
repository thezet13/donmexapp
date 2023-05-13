import 'package:flutter/material.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final bool readOnly;
  final Color textColor;

  AppTextField({
    Key? key,
    required this.textController,
    required this.hintText,
    required this.icon,
    required this.readOnly,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          bottom: 0,
        ),
        child: TextField(
          readOnly: readOnly,
          controller: textController,
          style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 18),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: AppColors.colorGreen, fontSize: 18),
            hintText: hintText,
            prefixIcon: Icon(icon, color: AppColors.colorGreen),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.h10),
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.colorDarkGreen2,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.h10),
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.colorDarkGreen2,
                )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.h10),
            ),
          ),
        ));
  }
}

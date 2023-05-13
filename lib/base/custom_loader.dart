import 'package:flutter/material.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Dimensions.h20 * 5,
        width: Dimensions.h20 * 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.h20 * 5 / 2),
          image: const DecorationImage(
              image: AssetImage("assets/images/donmex_logo.png"), fit: BoxFit.fill, opacity: 0.3),
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: AppColors.colorGreen),
      ),
    );
  }
}

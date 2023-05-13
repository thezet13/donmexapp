import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/controllers/navigation_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class BottomSheetWidget extends StatefulWidget {
  final Function(String) onOptionSelected;
  final Function(String) showSpotsBottomSheet;

  const BottomSheetWidget(
      {super.key, required this.onOptionSelected, required this.showSpotsBottomSheet});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  void _onOptionSelected(String option) {
    saveSelectedOption(option);

    setState(() {
      _selectedOption = option;
    });
    widget.onOptionSelected(option);

    if (option == '1' || option == '2') {
      Navigator.pop(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.showSpotsBottomSheet(option);
      });
    } else {
      Navigator.pop(context);
    }
  }
  // void _onOptionSelected(String option) {
  //   saveSelectedOption(option);
  //   setState(() {
  //     _selectedOption = option;
  //   });
  //   widget.onOptionSelected(option);
  //   Navigator.pop(context);
  // }

  Future<void> saveSelectedOption(String option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dm_serviceMode', option);
  }

  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
  }

  Future<void> _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedOption = prefs.getString('dm_serviceMode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.2,
      padding: EdgeInsets.all(Dimensions.h20 * 1.5),
      decoration: BoxDecoration(
        color: AppColors.colorDarkGreen3,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: Dimensions.w5 * 3, bottom: Dimensions.h5),
            child: Text(
              'want_to_order'.tr,
              style: TextStyle(fontSize: 22, color: AppColors.colorWhite),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _onOptionSelected('1'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.h20, vertical: Dimensions.h20),
              margin: EdgeInsets.only(bottom: Dimensions.h10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.h10),
                border: Border.all(width: 1, color: AppColors.colorDisabledG),
                color: _selectedOption == '1' ? AppColors.colorDisabledG : AppColors.colorDarkGreen,
              ),
              child: Row(
                children: [
                  //const SizedBox(width: 10),
                  Icon(Icons.store,
                      size: 32,
                      color: _selectedOption == '1' ? AppColors.colorWhite : AppColors.colorGreen),
                  SizedBox(width: Dimensions.w10),
                  Text('in_shop'.tr,
                      style: TextStyle(
                          fontSize: 24,
                          color: _selectedOption == '1'
                              ? AppColors.colorWhite
                              : AppColors.colorGreen)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onOptionSelected('2'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.h20, vertical: Dimensions.h20),
              margin: EdgeInsets.only(bottom: Dimensions.h10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.h10),
                border: Border.all(width: 1, color: AppColors.colorDisabledG),
                color: _selectedOption == '2' ? AppColors.colorDisabledG : AppColors.colorDarkGreen,
              ),
              child: Row(
                children: [
                  Icon(Icons.local_mall,
                      size: 32,
                      color: _selectedOption == '2' ? AppColors.colorWhite : AppColors.colorGreen),
                  const SizedBox(width: 10),
                  Text('take_away'.tr,
                      style: TextStyle(
                          fontSize: 24,
                          color: _selectedOption == '2'
                              ? AppColors.colorWhite
                              : AppColors.colorGreen)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _onOptionSelected('3');

              Get.find<NavigationController>().setPreviousRoute('selectServiceModeWidget');
              Get.toNamed(RouteHelper.getAddressPage());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.h20, vertical: Dimensions.h20),
              margin: EdgeInsets.only(bottom: Dimensions.h10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.h10),
                border: Border.all(width: 1, color: AppColors.colorDisabledG),
                color: _selectedOption == '3' ? AppColors.colorDisabledG : AppColors.colorDarkGreen,
              ),
              child: Row(
                children: [
                  Icon(Icons.delivery_dining,
                      size: 32,
                      color: _selectedOption == '3' ? AppColors.colorWhite : AppColors.colorGreen),
                  const SizedBox(width: 10),
                  Text('delivery'.tr,
                      style: TextStyle(
                          fontSize: 24,
                          color: _selectedOption == '3'
                              ? AppColors.colorWhite
                              : AppColors.colorGreen)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

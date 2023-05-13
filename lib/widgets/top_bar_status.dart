import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class TopBarStatus extends StatefulWidget {
  TopBarStatus({Key? key}) : super(key: key);

  @override
  TopBarStatusState createState() => TopBarStatusState();
}

class TopBarStatusState extends State<TopBarStatus> {
  String? _serviceMode;
  String? _selectedAddress;
  String? _selectedSpotName;
  String? _clientAddress;

  Future<void> saveSelectedOption(String option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dm_serviceMode', option);
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
    _loadSelectedAddress();
    _loadSelectedSpotName();
    _loadDeliveryAddress();
  }

  void updateServiceMode(String option) {
    setState(() {
      _serviceMode = option;
    });
  }

  void updateAddress(String address) {
    setState(() {
      _selectedAddress = address;
    });
  }

  void updateSpotName(String spot_name) {
    setState(() {
      _selectedSpotName = spot_name;
    });
  }

  Future<void> _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _serviceMode = prefs.getString('dm_serviceMode');
    });
  }

  Future<void> _loadSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedAddress = prefs.getString('dm_selectedAddress');
    });
  }

  Future<void> _loadSelectedSpotName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSpotName = prefs.getString('dm_selectedSpotName');
    });
  }

  Future<void> _loadDeliveryAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _clientAddress = prefs.getString('dm_clientAddress');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _serviceMode == null || _serviceMode!.isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: Dimensions.w5 * 5,
                      height: Dimensions.h5 * 5,
                      child: CircularProgressIndicator(color: AppColors.colorDarkGreen)),
                  SizedBox(width: Dimensions.w10),
                  Text('order_type'.tr,
                      style: TextStyle(color: AppColors.colorWhite, fontSize: 20)),
                  SizedBox(width: Dimensions.w10),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      _serviceMode == '1'
                          ? 'in_shop'.tr
                          : _serviceMode == '2'
                              ? 'take_away'.tr
                              : 'delivery'.tr,
                      style: TextStyle(color: AppColors.colorGreen, fontSize: 18)),
                  SizedBox(height: Dimensions.h5 - 2),
                  _serviceMode == '3'
                      ? Expanded(
                          child: Text(_clientAddress ?? 'choose_place'.tr,
                              style: TextStyle(color: AppColors.colorWhite, fontSize: 18),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis),
                        )
                      : Text(_selectedSpotName ?? 'choose_place'.tr,
                          style: TextStyle(color: AppColors.colorWhite, fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)
                ],
              ));
  }
}

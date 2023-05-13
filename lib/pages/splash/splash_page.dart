import 'dart:async';

import 'package:donmexapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/user_controller.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
    final authController = Get.find<AuthController>();
    final userController = Get.find<UserController>();
    final prefs = authController.authRepo.sharedPreferences;

    final _clientId = prefs.getString('dm_clientId') ?? '';

    bool _userLoggedIn = authController.userLoggedIn();
    if (_userLoggedIn) {
      userController.getUserInfo(_clientId);
    }

    // final _phone = prefs.getString('dm_phone') ?? '';
    // final _lastname = prefs.getString('dm_lastname') ?? '';
    // final _dmu = prefs.getString('dm_useraddress');
    // final _lat = prefs.getString('dm_lat');

    prefs.remove('dm_clientAddress');
    prefs.remove('dm_serviceMode');
    //print('${_spotId}');
    // print('${_clientId} ' + ' ${_phone} ' + ' ${_lastname}');
    // print('clientAddress: ' '${_clientAddress}');
    // print('lat: ' + '${_lat}');
    //   await Get.find<UserController>().getClientId(_phone);
    //await Get.find<ProductsListController>().getProductsList();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _loadResource();
    _clearServiceMode();
    _clearSpotName();

    controller = new AnimationController(vsync: this, duration: Duration(seconds: 2))..forward();
    animation = new CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    Timer(Duration(seconds: 2), () => Get.toNamed(RouteHelper.getInitial())
        //() => Get.toNamed(RouteHelper.getLanguage())
        );
  }

  Future<void> _clearServiceMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('dm_serviceMode');
  }

  Future<void> _clearSpotName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('dm_selectedSpotName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image:
            DecorationImage(image: AssetImage("assets/images/donmex_wall.png"), fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
                child: Image.asset(
              "assets/images/donmex_logo_name.png",
              width: Dimensions.splashImg,
            )),
          )
        ],
      ),
    ));
  }
}

import 'package:donmexapp/pages/splash/language_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/controllers/products_menu_controller.dart';
import 'package:donmexapp/pages/cart/cart_history.dart';
import 'package:donmexapp/pages/map/map.dart';
import 'package:donmexapp/utils/colors.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:just_audio/just_audio.dart';

import 'main_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Future<void> _loadResource() async {
    await Get.find<ProductsMenuController>().getProductsMenu();
  }

  final _serviceMode = Get.find<SharedPreferences>().getString('dm_serviceMode');

  // ignore: unused_field
  int _selectedIndex = 0;
  late PersistentTabController _controller;

  List pages = [
    const MainPage(),
    const CartHistory(),
    MapPage(),
    LanguagePage(),
  ];

  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _loadResource();
    WidgetsBinding.instance.addObserver(this);
    print('iam initial');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {}
  }

  List<Widget> _buildScreens() {
    return [
      const MainPage(),
      //const CartHistory(),
      const CartHistory(),
      MapPage(),
      LanguagePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: AppColors.colorGreen,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.cart_fill),
        title: ("Cart"),
        activeColorPrimary: AppColors.colorGreen,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.map_fill),
        title: ("Map"),
        activeColorPrimary: AppColors.colorGreen,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_fill),
        title: ("Profile"),
        activeColorPrimary: AppColors.colorGreen,
        inactiveColorPrimary: CupertinoColors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showExitConfirmation(context);
          return Future.value(false); // Prevent default back button behavior
        },
        child: Scaffold(
          body: MainPage(),
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return PersistentTabView(
  //     context,
  //     controller: _controller,
  //     screens: _buildScreens(),
  //     items: _navBarsItems(),
  //     confineInSafeArea: true,
  //     backgroundColor: AppColors.colorDarkGreen, // Default is Colors.white.
  //     handleAndroidBackButtonPress: true, // Default is true.
  //     resizeToAvoidBottomInset:
  //         true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
  //     stateManagement: true, // Default is true.
  //     hideNavigationBarWhenKeyboardShows:
  //         true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
  //     decoration: NavBarDecoration(
  //       borderRadius: BorderRadius.circular(0.0),
  //       colorBehindNavBar: const Color.fromARGB(255, 0, 0, 0),
  //     ),
  //     popAllScreensOnTapOfSelectedTab: true,
  //     popActionScreens: PopActionScreensType.all,
  //     itemAnimationProperties: const ItemAnimationProperties(
  //       // Navigation Bar's items animation properties.
  //       duration: Duration(milliseconds: 200),
  //       curve: Curves.ease,
  //     ),
  //     screenTransitionAnimation: const ScreenTransitionAnimation(
  //       // Screen transition animation on change of selected tab.
  //       animateTabTransition: true,
  //       curve: Curves.ease,
  //       duration: Duration(milliseconds: 200),
  //     ),
  //     navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
  //   );
  // }

  void showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.colorDarkGreen,
          title: Text(
            'Donmex'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 23),
          ),
          content: Text(
            'want_to_quit'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes'.tr,
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              onPressed: () {
                // Close the app
                SystemNavigator.pop();

                // Close the confirmation dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                'No'.tr,
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              onPressed: () {
                // Close the confirmation dialog without performing any action
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

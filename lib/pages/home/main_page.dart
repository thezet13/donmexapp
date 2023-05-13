import 'package:donmexapp/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/pages/account/account_page.dart';
import 'package:donmexapp/pages/cart/cart_page.dart';
import 'package:donmexapp/pages/home/menu_body.dart';
import 'package:donmexapp/widgets/top_bar_status.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<TopBarStatusState> topBarStatusKey = GlobalKey();

  final _controller = PageController(
    initialPage: 1,
  );

  String phone = '';

  @override
  void initState() {
    super.initState();
    _loadPhone();
  }

  Future<void> _loadPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 0, 0, 0),
      body: Container(
        decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage("assets/images/donmex_wall.png"), fit: BoxFit.fill),
        ),
        child: Column(children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                AccountPage(
                  toMenuBody: () => _controller.animateToPage(1,
                      duration: const Duration(milliseconds: 500), curve: Curves.slowMiddle),
                ),
                MenuBody(
                  toAccountPage: () => _controller.animateToPage(0,
                      duration: const Duration(milliseconds: 500), curve: Curves.slowMiddle),
                  onSpotSelected: (spot_name) {
                    topBarStatusKey.currentState?.updateSpotName(
                        spot_name); // Update the spot_name in the TopBarStatus widget
                  },
                ),
                const CartPage(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

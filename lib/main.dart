import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'app_constants.dart';
import 'controllers/language_controller.dart';
import 'helper/dependencies.dart' as dep;
import 'utils/messages.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // setPathUrlStrategy();
WidgetsFlutterBinding.ensureInitialized();
    await Future.delayed(Duration(milliseconds: 1000));

  Map<String, Map<String, String>> _languages = await dep.init();

  runApp(MyApp(languages: _languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (localizationController) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Donmex',
        locale: localizationController.locale,
        translations: Messages(languages: languages),
        fallbackLocale:
            Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode),
        initialRoute: RouteHelper.getSplashPage(),
        getPages: RouteHelper.routes,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.colorDarkGreen3,
          primaryColor: AppColors.colorDarkGreen,
          fontFamily: "RobotoCondensed",
        ),
        defaultTransition: Transition.topLevel,
      );
    });
  }
}

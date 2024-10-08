
import 'package:get/get.dart';
import 'package:multiple_flutters_module/information_page.dart';

import '../page/main/main_view.dart';
import '../page/splash/splash_view.dart';
// import '../ui/pages/main/main_view.dart';
// import '../ui/pages/splash/splash_view.dart';

class RouteConfig {
  ///main page
  static final String splash = "/splash";
  static final String main = "/main";
  static final String information_page="/information_page";

  ///Alias ​​mapping page
  static final List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashPage()),
    GetPage(name: main, page: () => MainPage()),
    GetPage(name: information_page, page: ()=>InformationPage())
  ];
}

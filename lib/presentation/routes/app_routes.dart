import 'package:flutter/material.dart';
import 'package:ecoreporte/presentation/pages/home_page.dart';
import 'package:ecoreporte/presentation/pages/login_page.dart';
import 'package:ecoreporte/presentation/pages/register_page.dart';
import 'package:ecoreporte/presentation/pages/home_app_page.dart';
import 'package:ecoreporte/presentation/pages/info_app_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => HomePage(),
    '/login': (context) => LoginPage(),
    '/register': (context) => RegisterPage(),
    '/home-app': (context) => HomeAppPage(),
    '/info-app': (context) => InfoAppPage(),
  };
}

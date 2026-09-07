import 'package:flutter/material.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/admin/admin_main_screen.dart';
import '../../screens/cashier/cashier_main_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String adminHome = '/admin';
  static const String cashierHome = '/cashier';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminMainScreen());
      case cashierHome:
        return MaterialPageRoute(builder: (_) => const CashierMainScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Route tidak ditemukan: ${settings.name}'))));
    }
  }
}
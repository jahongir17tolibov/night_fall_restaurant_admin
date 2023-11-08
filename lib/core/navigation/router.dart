import 'package:flutter/material.dart';
import 'package:night_fall_restaurant_admin/feature/add_new_product/add_new_product_screen.dart';
import 'package:night_fall_restaurant_admin/feature/editing_product/editing_product_screen.dart';
import 'package:night_fall_restaurant_admin/feature/splash/splash_screen.dart';
import 'package:night_fall_restaurant_admin/main.dart';

class RouterNavigation {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SplashScreen.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case MainScreen.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case EditingProductScreen.editingProductRoute:
        {
          String? productIdArg = routeSettings.arguments as String?;
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                EditingProductScreen(productIdArgument: productIdArg),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end)
                ..chain(CurveTween(curve: Curves.elasticInOut));
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        }
      case AddNewProductScreen.addNewProductRoute:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddNewProductScreen(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end)
                ..chain(CurveTween(curve: Curves.elasticInOut));
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            });
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${routeSettings.name}'),
                  ),
                ));
    }
  }
}

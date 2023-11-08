import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant_admin/core/theme/theme.dart';
import 'package:night_fall_restaurant_admin/feature/add_new_product/bloc/add_new_product_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/editing_product/bloc/editing_product_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/home/home_screen.dart';
import 'package:night_fall_restaurant_admin/feature/products/bloc/products_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/products/products_screen.dart';
import 'package:night_fall_restaurant_admin/feature/splash/splash_screen.dart';

import 'core/navigation/router.dart';
import 'di.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => getIt<HomeBloc>()),
        BlocProvider<ProductsBloc>(create: (context) => getIt<ProductsBloc>()),
        BlocProvider<EditingProductBloc>(
          create: (context) => getIt<EditingProductBloc>(),
        ),
        BlocProvider<AddNewProductBloc>(
          create: (context) => getIt<AddNewProductBloc>(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: RouterNavigation.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  static const String mainRoute = '/main';

  const MainScreen({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).popAndPushNamed(mainRoute);
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreenIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const ProductsScreen(),
  ];

  void onDestinationSelectState({required int destinationIndex}) {
    setState(() {
      _selectedScreenIndex = destinationIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationDestination> navigationDestinations = [
      // home
      NavigationDestination(
        selectedIcon: Icon(
          Icons.home_rounded,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        icon: Icon(
          Icons.home_outlined,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: 'Home',
      ),
      // cart
      NavigationDestination(
        selectedIcon: Icon(
          Icons.local_pizza_rounded,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        icon: Icon(
          Icons.local_pizza_outlined,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: 'Products',
      ),
    ];
    return Scaffold(
      body: SafeArea(child: screens[_selectedScreenIndex]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          indicatorColor: Colors.transparent,
          height: 70.0,
          elevation: 7.0,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 12.0,
              fontFamily: 'Ktwod',
            ),
          ),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: _selectedScreenIndex,
          onDestinationSelected: (int index) {
            onDestinationSelectState(destinationIndex: index);
          },
          destinations: navigationDestinations,
        ),
      ),
    );
  }
}

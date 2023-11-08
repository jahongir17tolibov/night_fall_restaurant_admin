import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:night_fall_restaurant_admin/main.dart';

class SplashScreen extends StatelessWidget {
  static const String splashRoute = '/';

  const SplashScreen({super.key});

  static const String _lottieFilePath = 'assets/anim/animation_lnom89oi.json';
  static final LottieBuilder _lottieAnimation =
      Lottie.asset(_lottieFilePath, width: 360, height: 360);
  static const Color _textColor = Color(0xffdfdff3);
  static const Color _backgroundColor = Color(0xFF0B1B26);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      await MainScreen.open(context);
    });

    return Scaffold(
      body: Container(
        color: _backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(child: _lottieAnimation),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Night fall Restaurant\nAdmin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 36.0,
                    fontFamily: 'GreatVibes',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

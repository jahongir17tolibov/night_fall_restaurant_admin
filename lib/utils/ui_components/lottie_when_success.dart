import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';

Widget showWhenAddedSuccessLottie(
  String lottie,
  String status,
  BuildContext context,
) =>
    Center(
      child: SizedBox(
        width: fillMaxWidth(context),
        height: fillMaxHeight(context) * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Lottie.asset(
              lottie,
              width: 200,
              height: 200,
              fit: BoxFit.fill,
              repeat: false,
            ),
            const SizedBox(height: 80),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 24.0,
                    fontFamily: 'Ktwod',
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );

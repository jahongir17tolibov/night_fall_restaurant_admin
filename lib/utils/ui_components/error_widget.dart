import 'package:flutter/material.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';

Widget errorWidget(String errorText, BuildContext context) => Center(
      child: SizedBox(
        width: fillMaxWidth(context),
        height: fillMaxHeight(context) * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextView(
            text: errorText,
            maxLines: 6,
            textColor: Theme.of(context).colorScheme.error,
            textSize: 20.0,
          ),
        ),
      ),
    );

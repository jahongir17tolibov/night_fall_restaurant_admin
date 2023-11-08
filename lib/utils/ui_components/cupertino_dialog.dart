import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';

void showCustomDialog({
  required BuildContext context,
  required String message,
  required VoidCallback onDeleteButtonPressed,
}) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => CupertinoAlertDialog(
      title: TextView(
        text: message,
        maxLines: 4,
        textColor: Theme.of(context).colorScheme.onSurface,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: TextView(
            text: "CANCEL",
            textColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        CupertinoDialogAction(
          onPressed: onDeleteButtonPressed,
          child: TextView(
            text: "DELETE",
            textColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

Widget buildTextField({
  required String hintText,
  double? width,
  TextAlign? textFieldAlign,
  TextInputType? textInputType,
  List<TextInputFormatter>? inputFormatter,
  required BuildContext context,
  required FocusNode textFieldFocusNode,
  required TextEditingController controller,
}) =>
    Container(
      width: width ??= fillMaxWidth(context),
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        keyboardType: textInputType ??= TextInputType.name,
        textInputAction: TextInputAction.next,
        cursorColor: Theme.of(context).colorScheme.secondary,
        cursorOpacityAnimates: true,
        maxLines: 1,
        textCapitalization: TextCapitalization.sentences,
        textAlign: textFieldAlign ??= TextAlign.start,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          labelText: hintText,
          floatingLabelStyle: TextStyle(
            color: textFieldFocusNode.hasFocus
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outline,
          ),
          hintMaxLines: 1,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.errorContainer,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          errorStyle: TextStyle(
              color: Theme.of(context).colorScheme.error, fontSize: 18.0),
          labelStyle: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          letterSpacing: 2.0,
          fontFamily: 'Ktwod',
          fontSize: 17.0,
        ),
      ),
    );

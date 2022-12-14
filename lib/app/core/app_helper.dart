import 'package:faux_spot/app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

SystemUiOverlayStyle uiOverlay(
    {required Color status,required Color navigate, Brightness? brightness}) {
  return SystemUiOverlayStyle(
    statusBarColor: status,
    systemNavigationBarColor: navigate,
    statusBarBrightness: brightness,
    systemNavigationBarIconBrightness: brightness,
  );
}

const space5 = SizedBox(height: 5, width: 5);
const space10 = SizedBox(height: 10, width: 10);
const space15 = SizedBox(height: 15, width: 15);
const space20 = SizedBox(height: 20, width: 20);
const space30 = SizedBox(height: 30, width: 30);

InputDecoration inputdecoration(
    {String? labelText, IconData? icon, String? iconn}) {
  return InputDecoration(
    prefixIcon: icon == null
        ? Iconify(iconn!, size: 16,)
        : Icon(
            icon,
            color: blackColor,
          ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    labelStyle: const TextStyle(color: blackColor, letterSpacing: 1),
    hintText: labelText,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: lightGreyColor,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: lightGreyColor,
      ),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: lightGreyColor,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: greyColor,
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import 'constants.dart';

class MyThemes {
  static const textTheme = TextTheme(
    //Label in figma
    bodyText1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    //Body in figma
    bodyText2: TextStyle(
      fontSize: 12,
    ),
    //Title in figma
    headline5: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    //Header in figma
    headline6: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
    button: TextStyle(
      fontSize: 14,
      color: orangeColor,
      fontWeight: FontWeight.w700,
    ),
  );

  static final lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'OpenSans',
    primaryColorBrightness: Brightness.light,
    brightness: Brightness.light,
    primaryColor: orangeColor,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: greyColor20,
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: blackColor,
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: orangeColor,
      elevation: 0,
    ),
    hoverColor: orangeColor20,
    dividerColor: greyColor40,
  );

  static final darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'OpenSans',
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.dark,
    primaryColor: orangeColor,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: blackColor80,
    backgroundColor: Colors.red,
    cardColor: blackColor60,
    bottomAppBarColor: blackColor60,
    cardTheme: CardTheme(
      color: blackColor60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: blackColor60,
      elevation: 10,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: orangeColor,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    hoverColor: blackColor80,
    dividerColor: greyColor,
  );
}

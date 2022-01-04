import 'package:flutter/material.dart';

//Colors
const Color blackColor = Color(0xFF121212);
const Color blackColor80 = Color(0xFF18181A);
const Color blackColor60 = Color(0xFF242527);

const Color greyColor = Color(0xFF505156);
const Color greyColor80 = Color(0xFF63646A);
const Color greyColor60 = Color(0xFF7F7F7F);
const Color greyColor40 = Color(0xFFE5E6EA);
const Color greyColor20 = Color(0xFFFAFAFA);

const Color orangeColor = Color(0xFFFF6000);
const Color orangeColor80 = Color(0xFFFE7235);
const Color orangeColor60 = Color(0xFFF4730B);
const Color orangeColor20 = Color(0xFFFFDFCB);

const Color darkBlue = Color(0xFF26242e);

//Enum

///Define action when add/ create album on Android
enum ACTION_TYPE {
  ///Move asset to new album folder de delete asset at old folder
  copy,

  ///Make a copy of asset and add to new album folder.
  move,
}

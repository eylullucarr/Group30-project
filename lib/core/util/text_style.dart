import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insulin_calculate/core/util/color.dart';

class CustomTextStyle {
  static TextStyle title = GoogleFonts.poppins(
      color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600);
  static TextStyle counterTitle = GoogleFonts.poppins(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400);

  static TextStyle counter = GoogleFonts.poppins(
      color: ColorUtility.lightCarminePink,
      fontSize: 18,
      fontWeight: FontWeight.w600);

  static TextStyle circleContainerHead = GoogleFonts.mulish(
      color: Colors.white, fontSize: 50, fontWeight: FontWeight.w800);
  static TextStyle circleContainerSubText = GoogleFonts.mulish(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700);

  static TextStyle calendarTileMonth = GoogleFonts.poppins(
      color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400);

  static TextStyle calendarTileYear = GoogleFonts.poppins(
      color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle calendarTileInusulinCounter = GoogleFonts.mulish(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800);
  static TextStyle calendarTileCarbohydrateCounter = GoogleFonts.mulish(
      color: Colors.black26, fontSize: 15, fontWeight: FontWeight.w400);

  static TextStyle foodTileText = GoogleFonts.poppins(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400);
}

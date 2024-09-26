import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color primaryColor = const Color(0xff000000);
  static Color accentColorDark = const Color(0xff6E6E6E);
  static Color accentColor = const Color(0xffF2F2F2);
  static Color errorColor = const Color(0xffFF0000);
  static Color infoColor = const Color(0xff0266E0);

  static TextStyle headerTextStyle = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w500,
    fontSize:20,
    color: primaryColor
  );

  static TextStyle bodyTextStyle2 = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w500,
    fontSize:12,
    color: accentColorDark
  );

  static TextStyle formTextStyle = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w500,
    fontSize:14,
    color: primaryColor
  );
  static TextStyle buttonTextStyle = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w600,
    fontSize:16,
    color: Colors.white
  );
}

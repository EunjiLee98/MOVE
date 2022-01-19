import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/front/gameSelect.dart';
import 'package:move/front/home.dart';
import 'package:move/front/training.dart';

Widget whiteRusso(String str, double num, bool bold) {
  return Text(
      str,
      style: GoogleFonts.getFont(
        'Russo One',
        textStyle: TextStyle(
            fontSize: num,
            color: Colors.white,
            fontWeight: bold ? FontWeight.bold : null
        ),)
  );
}

Widget navyRusso(String str, double num, bool bold) {
  return Text(
      str,
      style: GoogleFonts.getFont(
        'Russo One',
        textStyle: TextStyle(
            fontSize: num,
            color: const Color(0xff290055),
            fontWeight: bold ? FontWeight.bold : null
        ),)
  );
}

Widget whiteNoto(String str, double num, bool bold) {
  return Text(
      str,
      style: GoogleFonts.getFont(
        'Noto Sans',
        textStyle: TextStyle(
            fontSize: num,
            color: Colors.white,
            fontWeight: bold ? FontWeight.bold : null
        ),)
  );
}

Widget navyNoto(String str, double num, bool bold) {
  return Text(
      str,
      style: GoogleFonts.getFont(
        'Noto Sans',
        textStyle: TextStyle(
            fontSize: num,
            color: const Color(0xff290055),
            fontWeight: bold ? FontWeight.bold : null
        ),)
  );
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ab.dart';

DateTime get getNow => DateTime.now();

final minDate = DateTime(1950);
DateTime get maxDate => DateTime(getNow.year - 18, getNow.month, getNow.day);
final double gPadding = 16;
final gHPadding = EdgeInsets.symmetric(horizontal: 24);
final duration = Duration(milliseconds: 250);
final double buttonHeight = 56;
final appDateFormat = DateFormat('dd/MM/yyyy');
final serverDateFormat = DateFormat('yyyy-MM-dd');

bool isPhoneNo(String str) =>
    str.length == 11 && RegExp(r'[0-9]{11}$').hasMatch(str);

final bool isiOS = (defaultTargetPlatform == TargetPlatform.iOS);

String get userName => localStorage?.getString('userName') ?? '';
bool get isDriver => localStorage?.getBool('isDriver') ?? false;

bool is35T = false;
bool isQuizTest = false;
String versionStr = "20230913";
// final bool isWebApp = (defaultTargetPlatform != TargetPlatform.android &&
//     defaultTargetPlatform != TargetPlatform.iOS);

final bool isWebApp = kIsWeb;
final bool disableFallbackTimer = false;

String get device => localStorage?.getString('device') ?? '';

DateTime? stringToDate(String dateTime, bool isServer) {
  try {
    if (isServer) {
      return serverDateFormat.parse(dateTime);
    } else {
      return appDateFormat.parse(dateTime);
    }
  } catch (e) {
    print('Error wrong date ${e.toString()}');
    return null;
  }
}

String? dateToString(DateTime? dateTime, bool isServer) {
  try {
    if (dateTime != null) {
      if (isServer) {
        return serverDateFormat.format(dateTime);
      } else {
        return appDateFormat.format(dateTime);
      }
    } else {
      return null;
    }
  } catch (e) {
    print('Error wrong date ${e.toString()}');
    return null;
  }
}

String formatDate(DateTime date) => appDateFormat.format(date.toLocal());

enum FontStyle { bold, semiBold, medium, regular, light, extraLight }

class MyFonts {
  static TextStyle bold(double size, {Color? color}) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w800,
        fontSize: isiOS ? size : size - 2,
        color: color,
      );

  static TextStyle semiBold(double size, {Color? color}) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: isiOS ? size : size - 2,
        color: color ?? MyColors.darkBlue,
      );

  static TextStyle medium(double size, {Color? color}) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: isiOS ? size : size - 2,
        color: color,
      );

  static TextStyle regular(double size, {Color? color}) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: isiOS ? size : size - 2,
        color: color,
      );

  static TextStyle light(double size, {Color? color}) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300,
        fontSize: isiOS ? size : size - 2,
        color: color,
      );

  static TextStyle extraLight(double size, {Color? color}) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w200,
        fontSize: isiOS ? size : size - 2,
        color: color,
      );
}

class MyColors {
  // Core
  static const offWhite = Color.fromRGBO(226, 230, 253, 1);
  static const snowWhite = Color.fromRGBO(234, 237, 246, 1);
  static const grey = Color.fromRGBO(136, 137, 140, 1);
  static const darkBlue = Color.fromRGBO(025, 069, 136, 1);
  // Action
  static const green = Color.fromRGBO(108, 186, 123, 1);
  static const yellow = Color.fromRGBO(243, 171, 067, 1);
  static const pink = Color.fromRGBO(231, 116, 112, 1);
  static const lightBlue = Color.fromRGBO(032, 081, 156, 1);
  // Ancillary
  static const skyBlue = Color.fromRGBO(108, 187, 234, 1);
  static const ornage = Color.fromRGBO(237, 112, 075, 1);
  static const black = Color.fromRGBO(026, 028, 029, 1);
  // Extra
  static const white = Colors.white;
  static const transparent = Colors.transparent;
  static const lightGrey = Color.fromRGBO(211, 211, 211, 1);

  //v2 primary
  static const v2Primary = Color(0xFF00458D);
  static const v2Background = Color(0xFFF9F9FB);
  static const v2ArrowUp = Color(0xFF14C567);
  static const v2ArrowDown = Color(0xFFFF0000);
  static const v2WeekdayGrey = Color(0xFFE3E6EB);
  static const v2AccordionHeader = Color(0xFFBDE3FF);
  static const v2Green = Color(0xFF14C567);
}

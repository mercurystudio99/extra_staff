import 'package:device_info_plus/device_info_plus.dart';
import 'package:extra_staff/models/quick_add_tem_add_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class V2ProfileTempHolidayInfoController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, bool> sectionStates = {
    "Update Availability": false,
  };
  Future<String> getTempHolidayInfo(start_Date, end_date) async {
    final response =
        await Services.shared.getTempHolidayInfo(start_Date, end_date);
    if (response.result is Map) {}
    return response.errorMessage;
  }
}

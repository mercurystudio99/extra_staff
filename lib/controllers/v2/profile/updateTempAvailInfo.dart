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

class V2ProfileUpdateAvailabilityController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, bool> sectionStates = {
    "Update Availability": false,
  };
  Future<String> updateTempAvailInfo(Map<String, bool> selectedDays) async {
    final response = await Services.shared.updateTempAvailInfo(
        true, false, true, false, true, false, false, true);
    if (response.result is Map) {}
    return response.errorMessage;
  }
}

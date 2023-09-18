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

class V2ProfileHolidayAvailabilityController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<bool> availability = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Future<String> getTempAvailabilityInfo() async {
    final response = await Services.shared.getTempAvailabilityInfo();
    if (response.result is Map) {
      availability = [
        response.result['monday'] == 'true',
        response.result['tuesday'] == 'true',
        response.result['wednesday'] == 'true',
        response.result['thursday'] == 'true',
        response.result['friday'] == 'true',
        response.result['saturday'] == 'true',
        response.result['sunday'] == 'true',
        response.result['night_work'] == 'true'
      ];
    }
    return response.errorMessage;
  }
}

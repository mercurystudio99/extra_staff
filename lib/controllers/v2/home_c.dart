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

class V2HomeController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<int> weeklyShift = [0, 0, 0, 0, 0, 0, 0];

  Future<String> getTempAvailInfo() async {
    final response = await Services.shared.getTempAvailInfo();
    if (response.result is Map) {
      weeklyShift = [
        response.result['Mon'],
        response.result['Tue'],
        response.result['Wed'],
        response.result['Thu'],
        response.result['Fri'],
        response.result['Sat'],
        response.result['Sun']
      ];
    }
    return response.errorMessage;
  }
}

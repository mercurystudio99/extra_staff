import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class V2ProfileMyDetailsController extends GetxController {
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

  Future<String> getTempWorkHistoryInfo(
      String startDate, String endDate) async {
    final response =
        await Services.shared.getTempWorkHistoryInfo(startDate, endDate);
    return response.errorMessage;
  }
}

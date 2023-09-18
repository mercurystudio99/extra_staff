import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/models/quick_add_tem_add_m.dart';
import 'package:flutter/foundation.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ForgotPasscodeController extends GetxController {
  String phoneNo = '';
  String emailAddress = '';
  QuickAddTempAdd? result;
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validate() {
    return formKey.currentState!.validate();
  }

  Future verifyUserFromEmailPhone() async {
    if (emailAddress.endsWith("@extrastaff.com") &&
        emailAddress != "test@extrastaff.com") {
      return 'error_internal_user_register'.tr;
    }
    BaseApiResponse response =
        await Services.shared.verifyUserFromEmailPhone(emailAddress, phoneNo);
    if (response.errorMessage.isNotEmpty) {
      abShowMessage(response.errorMessage);
    } else {
      if (response.errorMessage.isEmpty) {
        result = QuickAddTempAdd.fromJson(response.result);
        await localStorage?.setInt('tempUserId', result!.userid);
        await localStorage?.setInt('tempTid', result!.tid);
        await Services.shared.setData();

        await initPlatformState();
        // response = await Services.shared
        //     .addDeviceDetails(emailAddress, _deviceData.toString());
        localStorage?.setString('device', _deviceData['device']);
        Services.shared.headers['DEVICE'] = device;
        response = await Services.shared.addDeviceDetails(emailAddress, device);
      }
      return response.errorMessage;
    }
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (isWebApp) {
        //web
        WebBrowserInfo browserInfo = await deviceInfoPlugin.webBrowserInfo;
        deviceData = {
          'device': 'AppWebBrowser:' + describeEnum(browserInfo.browserName)
        };
        //deviceData = {'device': 'AppWebBrowser'};
      } else {
        if (defaultTargetPlatform == TargetPlatform.android) {
          deviceData = {'device': (await deviceInfoPlugin.androidInfo).display};
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          deviceData = {
            'device': (await deviceInfoPlugin.iosInfo).identifierForVendor
          };
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    _deviceData = deviceData;
  }
}

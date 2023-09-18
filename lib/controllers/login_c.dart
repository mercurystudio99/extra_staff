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

class LoginController extends GetxController {
  String password = '';
  String emailAddress = '';
  bool withoutPassword = false;
  QuickAddTempAdd? result;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final localAuth = LocalAuthentication();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final allItems = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '+1',
    '0',
    '-1',
  ];

  Future<bool> checkAuth() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    if (!canCheckBiometrics) {
      return false;
    }

    try {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'authenticateBiometric'.tr,
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ));
      print(didAuthenticate);
      return didAuthenticate;
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> isBiometricsAvaliable() async {
    // bool isBiometricSupported = await localAuth.isDeviceSupported();
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    // abShowMessage('isBiometricSupported:' + isBiometricSupported.toString());
    // print('isBiometricSupported:' + isBiometricSupported.toString());
    // print('canCheckBiometrics:' + canCheckBiometrics.toString());

    if (!canCheckBiometrics) {
      return false;
    }

    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      return true;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> proceed(int index) async {
    if (index == 0) {
      bool next = await checkAuth();
      if (next) {
        await localStorage?.setBool('BioAuthEnabled', true);
        final response = await Services.shared.updateTempBioInfo();
        if (response.errorMessage.isNotEmpty) {
          abShowMessage(response.errorMessage);
          return false;
        }
      } else {
        await localStorage?.setBool('BioAuthEnabled', false);
      }
      return next;
    }
    await localStorage?.setBool('BioAuthEnabled', false);
    return true;
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  Future<String> login() async {
    BaseApiResponse response;
    if (emailAddress.endsWith("@extrastaff.com") &&
        emailAddress != "test@extrastaff.com") {
      return 'error_internal_user_register'.tr;
    }
    if (withoutPassword) {
      response = await Services.shared.tempVerificationByEmail(emailAddress);
    } else {
      // response = await Services.shared
      //     .postLogin(emailAddress, password, (isiOS ? 1 : 2));
      response =
          await Services.shared.verifyUserFromEmailPwd(emailAddress, password);
    }
    if (response.errorMessage.isEmpty) {
      result = QuickAddTempAdd.fromJson(response.result);
      await localStorage?.setInt('tempUserId', result!.userid);
      await localStorage?.setInt('tempTid', result!.tid);
      await Services.shared.setData();
      await initPlatformState();

      // response = await Services.shared
      //     .addDeviceDetails(emailAddress, _deviceData.toString());
      localStorage?.setString('device', _deviceData['device']);
      Services.shared.headers['DEVICE'] = _deviceData['device'];

      response = await Services.shared.addDeviceDetails(emailAddress, device);
    }
    return response.errorMessage;
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
        // deviceData = {'device': 'AppWebBrowser'};
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

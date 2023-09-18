import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/biometric_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/views/registration_progress_v.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';
import 'dart:convert';

class ChooseCode2 extends StatefulWidget {
  const ChooseCode2({Key? key}) : super(key: key);

  @override
  _ChooseCode2State createState() => _ChooseCode2State();
}

class _ChooseCode2State extends State<ChooseCode2> {
  TextEditingController pinCodeController = TextEditingController(text: '');
  bool isLoading = false;
  String code = '';

  @override
  initState() {
    super.initState();
    code = Get.arguments;
  }

  Widget getPinCodeText() {
    return abPinCodeText(context, 4, controller: pinCodeController,
        onCompleted: (v) async {
      if (v == code) {
        setState(() => isLoading = true);
        final name = userName;
        final post = isDriver;
        final storedDevice = device;
        await removeAllSharedPref();
        await Resume.shared.getClass();
        await localStorage?.setString('device', storedDevice);
        await localStorage?.setString('userName', name);
        await localStorage?.setBool('isDriver', post);
        await localStorage?.setInt('userId', Services.shared.tempUserId);
        await localStorage?.setInt('tid', Services.shared.tempTid);
        await Services.shared.setData();
        await localStorage?.setString('passcode', v);
        final message = await Services.shared.updateTempLogInfo();
        final message2 = await Services.shared.updateTempPassInfo();
        final message3 = await Services.shared.getTempProgressInfo();
        final deskInfo = await Services.shared.getTempDeskInfo();
        final tempCompDocInfo = await Services.shared.getTempCompDocInfo();
        final tempRolesInfo = await Services.shared.getTempRolesInfo();
        if (tempRolesInfo.result is Map &&
            tempRolesInfo.result['roles'] is String) {
          String selectedRoles = tempRolesInfo.result['roles'];
          bool isForklift = selectedRoles.contains('24');
          bool isOnly35T = false;
          is35T = false;
          if (selectedRoles.isNotEmpty) {
            final values = selectedRoles.split(',');
            is35T = values.contains('4');
            if (values.length == 1 && values.first == '4') {
              isOnly35T = true;
            }
          }

          final arguments = {
            'isForklift': isForklift,
            'selectedRoles': selectedRoles,
            'isOnly35T': isOnly35T,
            'is35T': is35T
          };
          final map = json.encode(arguments);
          await localStorage?.setString('RolesView', map);
        }

        if (tempCompDocInfo.result is Map) {
          (tempCompDocInfo.result as Map).forEach((key, value) async {
            if (key == 'is_have_ni') {
              await localStorage?.setBool('isNiUploaded', value['id'] != '1');
            }
          });
        }
        await getTempUserData();
        setState(() => isLoading = false);
        if (message.errorMessage.isNotEmpty ||
            message2.errorMessage.isNotEmpty ||
            message3.errorMessage.isNotEmpty) {
          abShowMessage(
              '${message.errorMessage} ${message2.errorMessage} ${message3.errorMessage}');
        } else {
          if (deskInfo.errorMessage.isNotEmpty) {
            abShowMessage(deskInfo.errorMessage);
          } else {
            if (deskInfo.result.containsKey('isDriver') &&
                deskInfo.result['isDriver'] is bool) {
              await localStorage?.setBool(
                  'isDriver', deskInfo.result['isDriver']);
            }
          }
          await Resume.shared.completedProgress(message3.result['screen_id']);
          await localStorage?.setString(
              'completed', message3.result['completed']);
          await Services.shared.setData();

          if (isWebApp) {
            if (Services.shared.completed == "Yes") {
              Get.offAll(() => RegistrationComplete());
              return;
            } else {
              Get.offAll(() => RegistrationProgress());
            }
          } else {
            Get.to(() => BiometricView(true));
          }
        }
      } else {
        pinCodeController.text = '';
        abShowMessage('passcodeNotMathcing'.tr);
      }
    }, onChanged: (value) {
      setState(() {});
    });
  }

  Widget getContent() {
    return Column(children: [
      SizedBox(height: 64),
      isWebApp
          ? Container(height: 60, width: 300, child: getPinCodeText())
          : getPinCodeText()
    ]);
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'confirmCode'.tr, showHome: false);
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithLoadingOverlayScaffoldContainer(context, isLoading,
        appBar: getAppBar(), content: getContent());
  }

  Future getTempUserData() async {
    await Services.shared.setData();
    final response = await Services.shared.getTempUserData();
    UserData data = UserData.fromJson({});
    if (response.result is Map) data = UserData.fromJson(response.result);
    if (response.errorMessage.isEmpty) {
      await localStorage?.setString(
          'userName', data.firstName + ' ' + data.lastName);
    } else {
      abShowMessage(response.errorMessage);
    }
  }
}

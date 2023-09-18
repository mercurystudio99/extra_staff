import 'package:extra_staff/controllers/login_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/login_v.dart';
import 'package:extra_staff/views/registration_progress_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'dart:convert';
import 'package:extra_staff/models/user_data_m.dart';

class EnterConfrimCode extends StatefulWidget {
  final bool isFromStart;
  const EnterConfrimCode({Key? key, required this.isFromStart})
      : super(key: key);

  @override
  _EnterConfrimCodeState createState() =>
      _EnterConfrimCodeState(isFromStart: isFromStart);
}

class _EnterConfrimCodeState extends State<EnterConfrimCode> {
  _EnterConfrimCodeState({required this.isFromStart});
  bool isLoading = false;
  bool isFromStart;
  int pinLength = 4;
  String pin = '';
  TextEditingController controller = TextEditingController(text: '');
  final loginController = LoginController();

  @override
  void initState() {
    super.initState();
    if (!isWebApp) {
      authBiometric();
    }
  }

  void authBiometric() async {
    final bioAuthEnabled = localStorage?.getBool('BioAuthEnabled') ?? false;
    if (bioAuthEnabled) {
      final isAuth = await loginController.checkAuth();
      if (isAuth) {
        final code = localStorage?.getString('passcode') ?? '';
        authProcess(code);
      }
    }
  }

  void authProcess(String passcode) async {
    setState(() => isLoading = true);
    final message3 = await Services.shared.getTempProgressInfo();
    print("++++++++++++++++message3");
    print(message3.result);
    if (message3.result.isEmpty ||
        (message3.result['screen_id'] == 0 &&
            message3.result['completed'] == "No")) {
      //new start or re-reg

      final tempTid = localStorage?.getInt('tid') ?? -1;
      final tempUserId = localStorage?.getInt('userId') ?? -1;
      final name = userName;
      final post = isDriver;
      final storedDevice = device;
      await removeAllSharedPref();
      await Resume.shared.getClass();
      await localStorage?.setString('device', storedDevice);
      await localStorage?.setString('userName', name);
      await localStorage?.setBool('isDriver', post);
      await localStorage?.setInt('userId', tempUserId);
      await localStorage?.setInt('tid', tempTid);
      await Services.shared.setData();
      await localStorage?.setString('passcode', passcode);
      final message = await Services.shared.updateTempLogInfo();
      final message2 = await Services.shared.updateTempPassInfo();
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
      }
    }

    // setState(() => isLoading = false);
    if (message3.result.isNotEmpty) {
      await Resume.shared.completedProgress(message3.result['screen_id']);
      await localStorage?.setString('completed', message3.result['completed']);
    }
    await Services.shared.setData();
    if (Services.shared.completed == "Yes") {
      Get.offAll(() => RegistrationComplete());
      return;
    }
    Get.offAll(() => RegistrationProgress());
  }

  Widget getPinCodeText() {
    bool readOnly = true;
    if (isWebApp) readOnly = false;

    return abPinCodeText(context, 4, controller: controller, readOnly: readOnly,
        onCompleted: (v) async {
      final code = localStorage?.getString('passcode') ?? '';
      if (code == v) {
        authProcess(v);
      } else {
        controller.text = '';
        pin = '';
        abShowMessage('passcodeNotMathcing'.tr);
      }
    }, onChanged: (value) {});
  }

  Widget getContent() {
    if (isWebApp) {
      return Column(children: [
        SizedBox(height: 64),
        Container(height: 60, width: 300, child: getPinCodeText()),
        Container(
          padding: gHPadding,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              textStyle: MyFonts.semiBold(17),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Get.to(() => LoginView(), arguments: true);
            },
            child: Text('Forgot Password'.toUpperCase(),
                style: TextStyle(color: MyColors.darkBlue)),
          ),
        )
      ]);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: gHPadding,
                    child: Center(
                      child: getPinCodeText(),
                    ),
                  ),
                  Container(
                    padding: gHPadding,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: MyFonts.semiBold(17),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Get.to(() => LoginView(), arguments: true);
                      },
                      child: Text('Forgot Password'.toUpperCase(),
                          style: TextStyle(color: MyColors.darkBlue)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: Get.height / 2,
            padding: EdgeInsets.all(16),
            color: MyColors.lightGrey.withAlpha(80),
            child: GridView.count(
              childAspectRatio: 1.5,
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: loginController.allItems
                  .map(
                    (item) => GridTile(
                      child: Container(
                        color: MyColors.white,
                        child: create(item),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
    }
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'enterCode'.tr,
        showHome: false, showBack: !isFromStart);
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithLoadingOverlayScaffoldContainer(context, isLoading,
        appBar: getAppBar(), content: getContent());
  }

  Widget create(item) {
    if (item == '-1') {
      return IconButton(
        onPressed: () {
          setState(() {
            if (pin.isNotEmpty) {
              pin = pin.substring(0, pin.length - 1);
            }
            controller.text = pin;
          });
        },
        icon: Icon(
          Icons.backspace_outlined,
          size: 35,
          color: MyColors.black,
        ),
      );
    } else if (item == '+1') {
      return IconButton(
        onPressed: () async {
          final isBiomatricAvaliable =
              true; //await loginController.isBiometricsAvaliable();
          if (isBiomatricAvaliable) {
            final isAuth = await loginController.checkAuth();
            if (isAuth) {
              if (Services.shared.completed == "Yes") {
                Get.offAll(() => RegistrationComplete());
                return;
              }
              Get.offAll(() => RegistrationProgress());
            } else {
              abShowMessage('passcodeNotMathcing'.tr);
            }
          } else {
            abShowMessage('error'.tr);
          }
        },
        icon: Image.asset('lib/images/face.png'),
      );
    } else {
      return TextButton(
        onPressed: () {
          setState(() {
            pin += item;
            controller.text = pin;
          });
        },
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: MyFonts.medium(40, color: MyColors.black),
        ),
      );
    }
  }
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

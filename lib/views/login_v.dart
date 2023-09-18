import 'package:extra_staff/controllers/login_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/choose_code_v.dart';
import 'package:extra_staff/views/enter_code_v.dart';
import 'package:extra_staff/views/enter_code_login_v.dart';
import 'package:extra_staff/views/forgot_passcode_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = LoginController();
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    if (Get.arguments != null) {
      setState(() {
        controller.withoutPassword = Get.arguments;
      });
    }
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        abTitle('emailAddress'.tr),
        SizedBox(height: 8),
        abTextField('', (text) => controller.emailAddress = text,
            keyboardType: TextInputType.emailAddress, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          } else if (!value.isEmail) {
            return 'validEmail'.tr;
          }
          return null;
        }, onFieldSubmitted: (e) async {}),
        if (!controller.withoutPassword) ...[
          SizedBox(height: 32),
          abTitle('enterPassword'.tr),
          SizedBox(height: 8),
          abPasswordField('', (text) => controller.password = text,
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 8),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: MyFonts.semiBold(17),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                Get.to(() => ForgotPasscodeView(), arguments: true);
              },
              child: Text('Forgot Password'.toUpperCase(),
                  style: TextStyle(color: MyColors.darkBlue)),
            ),
          ),
        ],
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(
        context, !controller.withoutPassword ? 'login'.tr : 'register'.tr,
        showHome: false);
  }

  Widget getBottomBar() {
    return abBottomNew(
      context,
      bottom: 'back'.tr,
      onTap: (i) async {
        if (i == 0) {
          setState(() => isLoading = true);
          final message = await controller.login();
          setState(() => isLoading = false);
          if (message.isEmpty) {
            if (controller.withoutPassword) {
              Get.to(() => EnterCode(), arguments: controller.result);
            } else {
              Get.to(() => EnterCodeLogin(), arguments: controller.result);
            }
          } else {
            abShowMessage(message);
          }
        } else {
          Get.back();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldFormScrollView(
        context, isLoading, controller.formKey,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

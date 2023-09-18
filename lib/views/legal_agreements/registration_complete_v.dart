import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/list_to_upload_v.dart';
import 'package:extra_staff/views/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/legal_agreements/hmrc_checklist_start_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/page_controller_v.dart';

class RegistrationComplete extends StatefulWidget {
  const RegistrationComplete({Key? key}) : super(key: key);

  @override
  _RegistrationCompleteState createState() => _RegistrationCompleteState();
}

class _RegistrationCompleteState extends State<RegistrationComplete> {
  @override
  void initState() {
    super.initState();
    saveProcess();
  }

  saveProcess() async {
    await localStorage?.setBool('isAgreementsCompleted', true);
    final result = await Services.shared.getTempProgressInfo();
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    } else {
      await localStorage?.setString('completed', result.result['completed']);
      await Services.shared.setData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          isWebApp
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 300.0,
                  ),
                  child: Image(
                      image: AssetImage('lib/images/comingSoon.png'),
                      width: double.infinity,
                      fit: BoxFit.fitWidth),
                )
              : Image(
                  image: AssetImage('lib/images/comingSoon.png'),
                  fit: BoxFit.fitWidth,
                ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 44),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Coming Soon ...',
                      textAlign: TextAlign.center,
                      style: MyFonts.regular(30, color: MyColors.darkBlue),
                    ),
                    SizedBox(height: 8),
                    isWebApp
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (!ResponsiveWidget.isSmallScreen(context))
                                Spacer(),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 2,
                                child: Container(
                                  padding: gHPadding,
                                  child: Column(
                                    children: [
                                      Text(
                                        "This is only the start of our app, stay tuned for new updates including ability to view your pay information/payslips, latest Extrastaff news, ability to check in and out of work and book your holidays all by the click of a button!",
                                        textAlign: TextAlign.center,
                                        style: MyFonts.regular(20,
                                            color: MyColors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (!ResponsiveWidget.isSmallScreen(context))
                                Spacer(),
                            ],
                          )
                        : Text(
                            "This is only the start of our app, stay tuned for new updates including ability to view your pay information/payslips, latest Extrastaff news, ability to check in and out of work and book your holidays all by the click of a button!",
                            textAlign: TextAlign.center,
                            style: MyFonts.regular(20, color: MyColors.grey),
                          ),
                  ],
                ),
              ),
            ),
          ),
          abBottomNew(
            context,
            top: 'Review Application',
            bottom: 'Logout',
            onTap: (i) async {
              if (i == 0) {
                await localStorage?.setBool('isAboutYouCompleted', false);
                await localStorage?.setBool(
                    'isEmploymentHistoryCompleted', false);
                await localStorage?.setBool('isCompetencyTestCompleted', false);
                await localStorage?.setBool('isAgreementsCompleted', false);
                await localStorage?.setString(
                    'LicenceType', 'LicenceType.licence');
                await Resume.shared.markAllNotDone();

                Get.offAll(() => RegistrationView());
              } else {
                await removeAllSharedPref();
                if (!disableFallbackTimer) {
                  if (timer != null) {
                    print('fallbackTimer stopped');
                    fallBackTimer(true);
                  }
                }
                if (isWebApp)
                  Get.offAll(() => PageControllerView());
                else
                  Get.offAll(() => SplashPage());
              }
            },
          ),
        ],
      ),
    );
  }
}

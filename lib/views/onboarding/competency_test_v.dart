import 'package:extra_staff/controllers/competency_test_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompetencyTest extends StatefulWidget {
  const CompetencyTest({Key? key}) : super(key: key);

  @override
  _CompetencyTestState createState() => _CompetencyTestState();
}

class _CompetencyTestState extends State<CompetencyTest> {
  final controller = CompetencyTestController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => isLoading = true);
    final message = await controller.getCompetancyInfo();
    setState(() => isLoading = false);
    if (message.isNotEmpty) {
      abShowMessage(message);
    }
  }

  Widget getContent() {
    return Container(
      padding: gHPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            size: 125,
            color: MyColors.lightBlue,
          ),
          SizedBox(height: 32),
          abWords('', '', WrapAlignment.center),
          SizedBox(height: 32),
          Text(
            'completingCompetency'.tr,
            style: MyFonts.regular(15),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Text(
            controller.scoreText(),
            style: MyFonts.regular(15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'ct'.tr);
  }

  Widget? getBottomBar() {
    return abBottomNew(
      context,
      bottom: 'back'.tr,
      onTap: (i) async {
        await Resume.shared.setDone(name: 'CompetencyTest');
        if (i == 0) {
          await localStorage?.setBool('isCompetencyTestCompleted', true);
          Get.off(() => RegistrationView());
        } else {
          Get.back(result: true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffold(context, isLoading,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

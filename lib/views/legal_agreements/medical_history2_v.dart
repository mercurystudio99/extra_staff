import 'package:extra_staff/controllers/legal_agreements/medical_history_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/medical_history3_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class MedicalHistory2 extends StatefulWidget {
  const MedicalHistory2({Key? key}) : super(key: key);

  @override
  _MedicalHistory2State createState() => _MedicalHistory2State();
}

class _MedicalHistory2State extends State<MedicalHistory2> {
  MedicalHistoryController controller = MedicalHistoryController();
  bool isReviewing = Services.shared.completed == "Yes";
  @override
  void initState() {
    super.initState();
    controller = Get.arguments['medicalHistory'];
  }

  Widget getContent() {
    final keys = controller.values.keys.toList();
    final value = controller.values.values.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: gHPadding,
          child: Column(
            children: [
              SizedBox(height: 32),
              abTitle('youSuffer?'.tr),
              SizedBox(height: 32),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: gHPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.values.length,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, position) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          activeColor: MyColors.darkBlue,
                          value: value[position],
                          enabled: !isReviewing,
                          onChanged: (v) => setState(() {
                            controller.values[keys[position]] = v!;
                            controller.setValues(position, v ? '1' : '2');
                          }),
                          title: abTitle(keys[position]),
                        ),
                        Divider(thickness: 2, color: MyColors.offWhite),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
                abTitle('furtherDetails'.tr),
                SizedBox(height: 8),
                abTextField(controller.data.medicalDesc,
                    (t) => controller.data.medicalDesc = t, maxLength: -1,
                    onFieldSubmitted: (p) {
                  next();
                }, readOnly: isReviewing),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'yourMedicalHistory'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(
      context,
      onTap: (i) async {
        if (i == 0) {
          next();
        }
      },
    );
  }

  Widget getMainWidget(BuildContext context,
      {required PreferredSizeWidget appBar,
      required Widget content,
      Widget? bottomBar}) {
    if (isWebApp) {
      return Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 2,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: content),
                  ),
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                ],
              ),
            ),
            if (bottomBar != null) bottomBar
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: content,
            ),
            if (bottomBar != null) bottomBar
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getMainWidget(context,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }

  next() async {
    if (isReviewing) {
      await Resume.shared.setDone(name: 'MedicalHistory2');
      Get.to(() => MedicalHistory3(),
          arguments: {'medicalHistory': controller});
      return;
    }
    final msg = controller.validate2();
    if (msg.isNotEmpty) {
      abShowMessage(msg);
      return;
    }
    await Resume.shared.setDone(name: 'MedicalHistory2');
    Get.to(() => MedicalHistory3(), arguments: {'medicalHistory': controller});
  }
}

import 'package:extra_staff/controllers/legal_agreements/interview_c.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/medical_history1_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';

class Interview extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<Interview> {
  final controller = InterviewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apicall();
  }

  apicall() async {
    setState(() => isLoading = true);
    await controller.getQuickTempVerification();
    setState(() => isLoading = false);
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 32),
        abTitle('likeInterviewConducted'.tr),
        SizedBox(height: 16),
        abDropDownButton(
            controller.interviewMethod, controller.dropDowns.methods, (e) {
          controller.interviewMethod = e;
          setState(() {});
        }),
        SizedBox(height: 16),
        abTitle('wtcyd'.tr),
        SizedBox(height: 16),
        abDropDownButton(controller.interviewTime, controller.dropDowns.times,
            (e) {
          controller.interviewTime = e;
          setState(() {});
        }),
        SizedBox(height: 16),
        abTitle('interviewDate'.tr),
        SizedBox(height: 16),
        abStatusButton(controller.interviewDateStr, null, () async {
          final now = getNow;
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: controller.interviewDate,
            firstDate: DateTime(now.year, now.month, now.day),
            lastDate: DateTime(now.year + 1, now.month, now.day),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light().copyWith(
                    primary:
                        MyColors.darkBlue, // Customize the selected color here
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null && picked != controller.interviewDate) {
            setState(() {
              controller.setInterviewDate(picked);
              controller.interviewDate = picked;
            });
          }
        }, hideStatus: true),
        SizedBox(height: 32),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'interview'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(
      context,
      top: 'finish'.tr,
      onTap: (i) async {
        if (i == 0) {
          final value = controller.validate();
          if (value.isNotEmpty) {
            abShowMessage(value);
          } else {
            final message = await controller.updateTempInterviewInfo();
            if (message.isNotEmpty) {
              abShowMessage(message);
              return;
            }
            await Resume.shared.setDone(name: 'Interview');
            await Services.shared.sendProgress('Interview'); // screen_id == 24
            Get.to(() => MedicalHistory1());
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldScrollView(
        context, isLoading,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

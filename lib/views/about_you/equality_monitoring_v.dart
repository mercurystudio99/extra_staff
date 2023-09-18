import 'package:extra_staff/controllers/about_you/equality_monitoring_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/about_you/details_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class EqualityMonitoring extends StatefulWidget {
  const EqualityMonitoring({Key? key}) : super(key: key);

  @override
  _EqualityMonitoringState createState() => _EqualityMonitoringState();
}

class _EqualityMonitoringState extends State<EqualityMonitoring> {
  final controller = EqualityMonitoringController();

  bool isLoading = false;
  bool isReviewing = Services.shared.completed == "Yes";
  @override
  void initState() {
    super.initState();
    getUserTempData();
  }

  getUserTempData() async {
    controller.data = Get.arguments['aboutYou'];
    try {
      controller.selectedAge = controller.stringToDate(controller.data.dob);
      controller.data.tempDob = controller.data.dob;
      setState(() => isLoading = true);
      await controller.getAndSetData();
      setState(() => isLoading = false);
    } catch (error) {
      print(error.toString());
    }
  }

  Widget button() {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          WillPopScope(onWillPop: () async => false, child: DetailsView()),
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
        );
      },
      child: Text(
        'Equal Opportunities',
        style: MyFonts.medium(25).merge(
          TextStyle(decoration: TextDecoration.underline),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        abTitle('nationalID'.tr),
        SizedBox(height: 8),
        abDropDownButton(controller.selectedNationalIdentity,
            controller.dropDowns.nationalIdentity, (value) {
          setState(() {
            controller.data.nationalIdentity = value.id;
            controller.selectedNationalIdentity = value;
          });
        }, disable: isReviewing),
        SizedBox(height: 16),
        abTitle('ethnicity'.tr),
        SizedBox(height: 8),
        abDropDownButton(controller.selectedEthnic, controller.dropDowns.ethnic,
            (value) {
          setState(() {
            controller.data.ethnic = value.id;
            controller.selectedEthnic = value;
          });
        }, disable: isReviewing),
        SizedBox(height: 16),
        abTitle('gender'.tr),
        SizedBox(height: 8),
        abDropDownButton(
            controller.selectedGender, controller.dropDowns.tempGender,
            (value) {
          setState(() {
            controller.data.tempGender = value.id;
            controller.selectedGender = value;
          });
        }, disable: isReviewing),
        SizedBox(height: 16),
        abTitle('religion'.tr),
        SizedBox(height: 8),
        abDropDownButton(
            controller.selectedReligion, controller.dropDowns.religion,
            (value) {
          setState(() {
            controller.data.religion = value.id;
            controller.selectedReligion = value;
          });
        }, disable: isReviewing),
        SizedBox(height: 16),
        abTitle('civilPartnerhip'.tr),
        SizedBox(height: 8),
        abRadioButtons(controller.marriedOrCivil, (b) {
          if (isReviewing) return;
          setState(() {
            controller.data.married = b == null ? '' : b.toString();
            controller.marriedOrCivil = b;
          });
        }, showIcon: true),
        SizedBox(height: 16),
        abTitle('disability'.tr),
        SizedBox(height: 8),
        abRadioButtons(controller.disability, (b) {
          if (isReviewing) return;
          setState(() {
            controller.data.tempDisability = b == null ? '' : b.toString();
            controller.disability = b;
          });
        }, showIcon: true),
        SizedBox(height: 16),
        abTitle('furtherDetails'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.tempDisabilityDesc,
            (p0) => controller.data.tempDisabilityDesc = p0, maxLines: 3,
            validator: (value) {
          if (controller.disability == true &&
              (value == null || value.isEmpty)) {
            return 'furtherDetails'.tr;
          }
          return null;
        }, readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('Age'.tr),
        SizedBox(height: 8),
        abStatusButton(formatDate(controller.selectedAge), null, () async {
          if (isReviewing) return;
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: controller.selectedAge,
            firstDate: minDate,
            lastDate: maxDate,
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
          if (picked != null && picked != controller.selectedAge) {
            setState(() {
              controller.selectedAge = picked;
              controller.setDate(picked);
            });
          }
        }, hideStatus: true),
        SizedBox(height: 16),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'Equal Opportunities', center: button());
  }

  Widget getBottomBar() {
    return abBottomNew(context, bottom: 'skip'.tr, onTap: (i) async {
      if (isReviewing) {
        await localStorage?.setBool('isAboutYouCompleted', true);
        await Resume.shared.setDone(name: 'EqualityMonitoring');
        Get.off(() => RegistrationView());
        return;
      }
      setState(() => isLoading = true);
      final message = await controller.updateTempEqualityInfo();
      setState(() => isLoading = false);
      if (message.isEmpty) {
        await localStorage?.setBool('isAboutYouCompleted', true);
        await Resume.shared.setDone(name: 'EqualityMonitoring');
        await Services.shared
            .sendProgress('EqualityMonitoring'); // screen_id == 8
        Get.off(() => RegistrationView());
      } else {
        abShowMessage(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldFormScrollView(
        context, isLoading, controller.formKey,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

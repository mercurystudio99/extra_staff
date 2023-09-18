import 'package:extra_staff/controllers/legal_agreements/medical_history_c.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';

class MedicalHistory3 extends StatefulWidget {
  const MedicalHistory3({Key? key}) : super(key: key);

  @override
  _MedicalHistory3State createState() => _MedicalHistory3State();
}

class _MedicalHistory3State extends State<MedicalHistory3> {
  bool isLoading = false;
  MedicalHistoryController controller = MedicalHistoryController();
  bool isReviewing = Services.shared.completed == "Yes";
  @override
  void initState() {
    super.initState();
    controller = Get.arguments['medicalHistory'];
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        abTitle('receivingMedicalTreatment?'.tr),
        SizedBox(height: 8),
        abRadioButtons(controller.treatment, (p0) {
          if (isReviewing) return;
          setState(() {
            controller.data.treatment = p0! ? '1' : '2';
            controller.treatment = p0;
          });
        }),
        SizedBox(height: 16),
        abTitle('furtherDetails'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.treatmentData,
            (p0) => controller.data.treatmentData = p0,
            maxLines: 3, readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('takenAnyDrugsMedicines?'.tr),
        SizedBox(height: 8),
        abRadioButtons(controller.drug, (p0) {
          if (isReviewing) return;
          setState(() {
            controller.data.drug = p0! ? '1' : '2';
            controller.drug = p0;
          });
        }),
        SizedBox(height: 16),
        abTitle('furtherDetails'.tr),
        SizedBox(height: 8),
        abTextField(
            controller.data.drugData, (p0) => controller.data.drugData = p0,
            maxLines: 3, readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('detailsOfAllIllnesses'.tr),
        SizedBox(height: 16),
        abTextField(controller.data.illnessData,
            (p0) => controller.data.illnessData = p0,
            maxLines: 3, readOnly: isReviewing),
        SizedBox(height: 32),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'yourMedicalHistory'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(
      context,
      top: 'save'.tr,
      bottom: null,
      onTap: (i) async {
        if (i == 0) {
          next();
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

  next() async {
    if (isReviewing) {
      await Resume.shared.setDone(name: 'MedicalHistory3');
      Get.off(() => RegistrationComplete());
      return;
    }
    final msg = controller.validate3();
    if (msg.isNotEmpty) {
      abShowMessage(msg);
      return;
    }
    setState(() => isLoading = true);
    await Resume.shared.markAllDone();
    final message = await controller.updateTempMedicalInfo();
    setState(() => isLoading = false);
    if (message.isEmpty) {
      await Resume.shared.setDone(name: 'MedicalHistory3');
      await Services.shared.sendProgress('MedicalHistory3'); // screen_id == 27
      Get.bottomSheet(
        NewInfoView(6, () {
          Get.off(() => RegistrationComplete());
        }),
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
      );
    } else {
      abShowMessage(message);
    }
  }
}

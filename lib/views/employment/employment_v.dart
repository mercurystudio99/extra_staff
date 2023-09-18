import 'package:extra_staff/controllers/list_to_upload_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/employment/employment_history_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:extra_staff/views/upload_documents_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class EmploymentView extends StatefulWidget {
  @override
  State<EmploymentView> createState() => _EmploymentViewState();
}

class _EmploymentViewState extends State<EmploymentView> {
  final controller = ListToUploadController();
  bool isLoading = false;
  bool isReviewing = Services.shared.completed == "Yes";

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  apiCall() async {
    setState(() => isLoading = true);
    await controller.getTempCVInfo();
    setState(() => isLoading = false);
  }

  Widget getContent() {
    if (isReviewing) {
      return Column(
        children: [
          SizedBox(height: 32),
          controller.isCVUploaded
              ? abSimpleButton(
                  'CV Uploaded',
                  onTap: () {},
                  backgroundColor: MyColors.green,
                )
              : abSimpleButton('Manual History', onTap: () async => action(1)),
          SizedBox(height: 32),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 32),
          abSimpleButton(
            'Upload CV',
            onTap: () async => await action(0),
            backgroundColor: controller.isCVUploaded ? MyColors.green : null,
          ),
          SizedBox(height: 16),
          abTitle('Or'),
          SizedBox(height: 16),
          abSimpleButton('Enter manually', onTap: () async => await action(1)),
          SizedBox(height: 32),
        ],
      );
    }
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'Employment'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        await localStorage?.setBool('isEmploymentHistoryCompleted', true);
        await Resume.shared.setDone(name: 'EmploymentView');
        if(!isReviewing) {
          await Services.shared.sendProgress('EmploymentView');
        } // screen_id == 11
        Get.off(() => RegistrationView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Services.shared.completed == "Yes") {
      return abMainWidgetWithBottomBarLoadingOverlayScaffoldFormScrollView(
          context, isLoading, controller.formKey,
          appBar: getAppBar(),
          content: getContent(),
          bottomBar: getBottomBar());
    } else {
      return abMainWidgetWithLoadingOverlayScaffoldContainer(context, isLoading,
          appBar: getAppBar(), content: getContent());
    }
  }

  action(int index) async {
    bool result = false;
    if (index == 0) {
      result = await Get.to(() => UploadDocumentsView(controller: controller),
          arguments: {'isCV': true});
    } else {
      result =
          await Get.to(() => EmploymentHistory(), arguments: {'isCV': true});
    }
    if (result) {
      await localStorage?.setBool('isEmploymentHistoryCompleted', true);
      await Resume.shared.setDone(name: 'EmploymentView');
      if(!isReviewing) {
          await Services.shared.sendProgress('EmploymentView');
      } // screen_id == 11
      Get.off(() => RegistrationView());
    }
  }
}

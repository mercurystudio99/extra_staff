import 'package:extra_staff/controllers/legal_agreements/agreements_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/interview_v.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/legal_agreements/medical_history1_v.dart';

class UserConfirmationView extends StatefulWidget {
  const UserConfirmationView({Key? key}) : super(key: key);

  @override
  _UserConfirmationViewState createState() => _UserConfirmationViewState();
}

class _UserConfirmationViewState extends State<UserConfirmationView> {
  final sign = GlobalKey<SignatureState>();
  final controller = AgreementsController();
  bool isLoading = false;
  var data = [
    {"Extrastaff's Workplace Pension": false},
    {'Now Pension': false},
    {'The Code of Conduct': false},
    {'Privacy Statement': false},
    {'Manual Handling Guide': false},
    {'Terms of Engagement': false},
  ];
  bool isReviewing = Services.shared.completed == "Yes";

  @override
  void initState() {
    super.initState();
    data.add({
      'I $userName confirm that I give Extrastaff consent to seek a reference about me, and issue a reference about me if requested.':
          false
    });
    data.add({
      'I $userName confirm I have read and agree to the Terms of Engagement':
          false
    });
    if (Resume.shared.progress == 100) {
      for (var i = 0; i < data.length; i++) {
        data[i][data[i].keys.first] = true;
      }
    }
    setState(() {});
  }

  Widget checkList(int index) {
    return CheckboxListTile(
      title: Text(data[index].keys.first),
      contentPadding: EdgeInsets.zero,
      activeColor: MyColors.darkBlue,
      value: data[index].values.first,
      enabled: !isReviewing,
      onChanged: (newValue) {
        data[index] = {data[index].keys.first: newValue ?? false};
        setState(() {});
      },
    );
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 32),
        abTitle('I $userName confirm that I have read and understood:'.tr),
        SizedBox(height: 32),
        for (var i = 0; i < data.length; i++) checkList(i),
        SizedBox(height: 32),
        abWords('requireSign'.tr, 'signature', WrapAlignment.start),
        SizedBox(height: 8),
        Container(
          height: 300,
          color: MyColors.lightGrey.withOpacity(0.5),
          child: Signature(key: sign),
        ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {
            sign.currentState?.clear();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(MyColors.darkBlue),
          ),
          child: Text(
            'Clear',
            style: MyFonts.bold(17, color: MyColors.white),
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'agreements'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        if (isReviewing) {
          Get.to(() => MedicalHistory1());
          return;
        }
        for (var i = 0; i < data.length; i++) {
          if (data[i].values.first == false) {
            abShowMessage('selectAllAgreements'.tr);
            return;
          }
        }
        final si = sign.currentState;
        if (!(si?.hasPoints ?? false)) {
          abShowMessage('requireSign'.tr);
          return;
        }
        setState(() => isLoading = true);
        final image = await si?.getData();
        var iData = await image?.toByteData(format: ui.ImageByteFormat.png);
        final xFile = XFile.fromData(iData!.buffer.asUint8List());
        si?.clear();
        final message = await controller.putSignature(xFile);
        setState(() => isLoading = false);
        if (message != 'OK') {
          abShowMessage(message);
          return;
        }
        await Resume.shared.setDone(name: 'UserConfirmationView');
        await Services.shared
            .sendProgress('UserConfirmationView'); // screen_id == 23
        Get.bottomSheet(
          NewInfoView(8, () {
            Get.to(() => Interview());
          }),
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldScrollView(
        context, isLoading,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

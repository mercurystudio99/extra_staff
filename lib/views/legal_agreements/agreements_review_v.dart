import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/controllers/legal_agreements/agreements_c.dart';
import 'package:extra_staff/views/legal_agreements/agreement1_v.dart';
import 'package:extra_staff/views/legal_agreements/medical_history1_v.dart';
import 'dart:convert';
import 'dart:typed_data';

class AgreementsReView extends StatefulWidget {
  const AgreementsReView({Key? key}) : super(key: key);

  @override
  _AgreementsReViewState createState() => _AgreementsReViewState();
}

class _AgreementsReViewState extends State<AgreementsReView> {
  final controller = AgreementsController();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getSignatureInfo();
  }

  getSignatureInfo() async {
    try {
      setState(() => isLoading = true);
      final response = await controller.getTempSignatureInfo();

      setState(() => isLoading = false);
    } catch (error) {
      print(error.toString());
    }
  }

  Widget agreement(KeyValue index) {
    return Column(
      children: [
        abStatusButton(index.value, true, () async {
          controller.currentIndex = int.parse(index.id);
          await navigate();
        }, hideStatus: false),
        SizedBox(height: 16),
      ],
    );
  }

  navigate() async {
    await Resume.shared.setDone(name: 'AgreementsView');
    final value = await Get.to(() => Agreement1(), arguments: controller);
    if (value == null) {
      final message = await controller.getTempAgreementInfo();
      if (message.isNotEmpty) abShowMessage(message);
      setState(() {});
    }
  }

  Widget getContent() {
    Uint8List signatureImage = Base64Codec().decode(controller.signatureBlob);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        for (var i in controller.allAgreements) agreement(i),
        SizedBox(height: 16),
        Text('agreement_extra1'.tr),
        SizedBox(height: 16),
        Text('agreement_extra2'.tr),
        SizedBox(height: 16),
        Text('signed'.tr),
        SizedBox(height: 16),
        if (controller.signatureBlob != '') ...[
          Container(
            child: Image.memory(signatureImage),
            margin: EdgeInsets.symmetric(horizontal: 24),
          )
        ],
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'agreements'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        Get.to(() => MedicalHistory1());
        return;
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

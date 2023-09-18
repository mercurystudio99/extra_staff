import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/choose_code2_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseCode extends StatefulWidget {
  const ChooseCode({Key? key}) : super(key: key);

  @override
  _ChooseCodeState createState() => _ChooseCodeState();
}

class _ChooseCodeState extends State<ChooseCode> {
  bool isLoading = false;

  Widget getPinCodeText() {
    return abPinCodeText(context, 4, onCompleted: (v) async {
      Get.to(() => ChooseCode2(), arguments: v);
    }, onChanged: (value) {});
  }

  Widget getContent() {
    return Column(children: [
      SizedBox(height: 64),
      isWebApp
          ? Container(height: 60, width: 300, child: getPinCodeText())
          : getPinCodeText()
    ]);
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'chooseCode'.tr, showHome: false);
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithLoadingOverlayScaffoldContainer(context, isLoading,
        appBar: getAppBar(), content: getContent());
  }
}

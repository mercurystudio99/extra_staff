import 'package:extra_staff/controllers/about_you/bank_details_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/about_you/equality_monitoring_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  _BankDetails createState() => _BankDetails();
}

class _BankDetails extends State<BankDetails> {
  final controller = BankDetailsController();
  Map<String, dynamic> allData = {};
  bool isLoading = false;
  bool isReviewing = Services.shared.completed == "Yes";

  @override
  void initState() {
    super.initState();
    controller.data = Get.arguments['aboutYou'];
    controller.dropDowns = Get.arguments['dropDowns'];
    allData = {'aboutYou': controller.data, 'dropDowns': controller.dropDowns};
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        abTitle('bankName'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.bankName, (text) {
          controller.data.bankName = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          return null;
        }, readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('sortCode'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.bankSortcode, (text) {
          controller.data.bankSortcode = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          if (!RegExp(r'[0-9]{6}$').hasMatch(value)) {
            return 'bankSortCode'.tr;
          }
          return null;
        },
            maxLength: 6,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('bankAccountNumber'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.bankAccount, (text) {
          controller.data.bankAccount = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          if (!RegExp(r'[0-9]{8}$').hasMatch(value)) {
            return 'validBankAccountNumber'.tr;
          }
          return null;
        },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            maxLength: 8,
            readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('bankHolderName'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.bankHolderName, (text) {
          controller.data.bankHolderName = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          return null;
        }, readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('bankReference'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.bankReference, (text) {
          controller.data.bankReference = text;
        }, validator: (value) {
          return null;
        }, onFieldSubmitted: (e) => next(), readOnly: isReviewing),
        SizedBox(height: 16),
        SizedBox(height: 8),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'payingYou'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        next();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldFormScrollView(
        context, isLoading, controller.formKey,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }

  next() async {
    if (isReviewing) {
      await Resume.shared.setDone(name: 'BankDetails');
      Get.to(() => EqualityMonitoring(), arguments: allData);
      return;
    }
    if (!controller.formKey.currentState!.validate()) {
      abShowMessage('error'.tr);
      return;
    }
    setState(() {
      isLoading = true;
    });
    final message = await controller.updateTempInfo();
    setState(() {
      isLoading = false;
    });
    if (message.isEmpty) {
      await Resume.shared.setDone(name: 'BankDetails');
      await Services.shared.sendProgress('BankDetails'); // screen_id == 7
      Get.to(() => EqualityMonitoring(), arguments: allData);
    } else {
      abShowMessage(message);
    }
  }
}

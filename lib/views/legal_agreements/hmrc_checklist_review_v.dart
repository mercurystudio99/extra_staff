import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/controllers/legal_agreements/hmrc_checklist_c.dart';
import 'package:extra_staff/views/legal_agreements/agreements_review_v.dart';

class HMRCChecklistReView extends StatefulWidget {
  const HMRCChecklistReView({Key? key}) : super(key: key);

  @override
  _HMRCChecklistReViewState createState() => _HMRCChecklistReViewState();
}

class _HMRCChecklistReViewState extends State<HMRCChecklistReView> {
  final controller = HMRCCheckListController();
  bool isLoading = false;
  bool isHMRCCompleted = localStorage?.getBool('isHMRCCompleted') ?? false;
  @override
  void initState() {
    super.initState();
    getData();
    isHMRCCompleted = true;
  }

  getData() async {
    setState(() => isLoading = true);
    final message = await controller.getTempHMRCInfo();
    setState(() => isLoading = false);
    if (message.isNotEmpty) abShowMessage(message);
  }

  Widget quezWidget(String quez, String answer, WrapAlignment? alignment,
      {Color? textColor, double? size}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: alignment ?? WrapAlignment.spaceBetween,
          children: [
            Text(
              quez,
              style: MyFonts.regular(size ?? 16,
                  color: textColor ?? MyColors.black),
            ),
            Text(answer,
                style: MyFonts.bold(size ?? 16,
                    color: textColor ?? MyColors.darkBlue)),
          ],
        ),
      ],
    );
  }

  Widget getContent() {
    final statementOptionIndex =
        (int.tryParse(controller.answers[0].value) ?? 1) - 1;
    return SingleChildScrollView(
      padding: gHPadding,
      child: Column(
        children: [
          SizedBox(height: 16),
          abStatusButton(
            controller.options[statementOptionIndex],
            true,
            () {},
            hideStatus: true,
            expanded: true,
            borderWidth: 2,
          ),
          const Divider(
            height: 48,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.grey,
          ),
          for (var quezIndex = 0;
              quezIndex < controller.questionsForReview.length;
              quezIndex++) ...[
            controller.answers[quezIndex + 1].value != ''
                ? abStatusButtonWidget(
                    quezWidget(
                        '${quezIndex + 1}/${controller.questionsForReview.length} ${controller.questionsForReview[quezIndex]}',
                        quezIndex == 3
                            ? (controller.answers[quezIndex + 1].value == '1'
                                ? 'plan1'.tr
                                : (controller.answers[quezIndex + 1].value ==
                                        '2'
                                    ? 'plan2'.tr
                                    : 'both'.tr))
                            : (controller.answers[quezIndex + 1].value == '1'
                                ? 'yes'.tr
                                : 'no'.tr),
                        null),
                    null,
                    () {},
                    expanded: true,
                    hideStatus: true)
                : Container(),
            controller.answers[quezIndex + 1].value != ''
                ? SizedBox(height: 16)
                : Container(),
          ]
        ],
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'HMRC Checklist');
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        Get.to(() => AgreementsReView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffold(context, isLoading,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

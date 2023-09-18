import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/legal_agreements/hmrc_checklist_v.dart';
import 'package:extra_staff/views/legal_agreements/agreements_v.dart';
import 'package:extra_staff/controllers/legal_agreements/hmrc_checklist_c.dart';

class HMRCChecklistStartView extends StatefulWidget {
  const HMRCChecklistStartView({Key? key}) : super(key: key);

  @override
  _HMRCChecklistStartViewState createState() => _HMRCChecklistStartViewState();
}

class _HMRCChecklistStartViewState extends State<HMRCChecklistStartView> {
  final controller = HMRCCheckListController();
  bool isLoading = false;
  var passedData = {};
  bool isHMRCCompleted = localStorage?.getBool('isHMRCCompleted') ?? false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    passedData = Get.arguments;
    setState(() => isLoading = true);
    final message = await controller.getTempHMRCInfo();
    setState(() => isLoading = false);
    if (message.isNotEmpty) abShowMessage(message);
  }

  Widget getContent() {
    return Column(
      children: [
        SizedBox(height: 32),
        Container(
          padding: gHPadding,
          child: Column(
            children: [
              abWords('Employment Statement', 'Statement', null),
              SizedBox(height: 16),
              abTitle('selectStatement'.tr),
            ],
          ),
        ),
        SizedBox(height: 32),
        Expanded(
          child: SingleChildScrollView(
            padding: gHPadding,
            child: Column(
              children: [
                for (var i in controller.options) ...[
                  abStatusButton(
                    i,
                    controller.answers[controller.selectedIndex].value ==
                            '${controller.options.indexOf(i) + 1}'
                        ? true
                        : null,
                    () {
                      final index = controller.options.indexOf(i);
                      setState(() {
                        controller.selectedIndex = 0;
                        controller.answers[0].value = '${index + 1}';
                      });
                      Future.delayed(duration * 2, () async {
                        await Resume.shared
                            .setDone(name: 'HMRCChecklistStartView');
                        passedData['answers'] = controller.answers[0];
                        Get.to(() => HMRCChecklistView(),
                            arguments: passedData);
                      });
                    },
                    hideStatus: true,
                    expanded: true,
                    borderWidth: 3,
                  ),
                  SizedBox(height: 32),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'HMRC Checklist');
  }

  Widget getBottomBar() {
    if (isHMRCCompleted) {
      return abBottomNew(context, onTap: (i) async {
        if (i == 0) {
          Get.to(() => AgreementsView());
        }
      });
    } else
      return abBottomNew(context, top: null);
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffold(context, isLoading,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

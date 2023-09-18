import 'package:extra_staff/controllers/working_with_us/skills_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/working_with_us/licences_upload_v.dart';
import 'package:extra_staff/views/working_with_us/availability2_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class SkillsView extends StatefulWidget {
  const SkillsView({Key? key}) : super(key: key);

  @override
  _SkillsViewState createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView> {
  Map<String, dynamic> allData = {};
  final controller = SkillsViewController();
  bool isLoading = false;
  bool isReviewing = Services.shared.completed == "Yes";
  @override
  void initState() {
    super.initState();
    controller.data = Get.arguments['aboutYou'];
    controller.dropDowns = Get.arguments['dropDowns'];
    allData = {'aboutYou': controller.data, 'dropDowns': controller.dropDowns};
    setData();
  }

  setData() async {
    setState(() => isLoading = true);
    controller.getDataFromStorage();
    await controller.apiCalls();
    setState(() => isLoading = false);
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text(
          'topSkills'.tr,
          style: MyFonts.regular(18, color: MyColors.lightBlue),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: controller.skills.length,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, position) {
            return Column(
              children: [
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: MyColors.darkBlue,
                  value: controller.isSelected(position),
                  enabled: !isReviewing,
                  onChanged: (v) => setState(() {
                    controller.addOrRemoveRole(position);
                  }),
                  title: abTitle(controller.skills[position].value),
                ),
                Divider(thickness: 2, color: MyColors.offWhite),
              ],
            );
          },
        ),
        SizedBox(height: 32),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'skillsForYou'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        if (isReviewing) {
          await Resume.shared.setDone(name: 'SkillsView');
          Get.to(() => isDriver ? LicencesUploadView() : Availability2(),
              arguments: allData);
          return;
        }
        final message = await controller.updateTempSkillsInfo();
        if (message.isNotEmpty) {
          abShowMessage(message);
          return;
        }
        await Resume.shared.setDone(name: 'SkillsView');
        await Services.shared.sendProgress('SkillsView'); // screen_id == 13
        Get.to(() => isDriver ? LicencesUploadView() : Availability2(),
            arguments: allData);
      } else {
        Get.back(result: true);
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

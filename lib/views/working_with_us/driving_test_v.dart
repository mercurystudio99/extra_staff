import 'package:extra_staff/controllers/working_with_us/driving_test_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:extra_staff/views/onboarding/onboarding_wizard_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/onboarding/competency_test_v.dart';

class DrivingTestView extends StatefulWidget {
  @override
  _DrivingTestViewState createState() => _DrivingTestViewState();
}

class _DrivingTestViewState extends State<DrivingTestView> {
  bool isLoading = false;
  final controller = DrivingTestController();
  final tableBorder = TableBorder(
    top: BorderSide(color: MyColors.lightGrey),
    horizontalInside: BorderSide(color: MyColors.lightGrey),
    bottom: BorderSide(color: MyColors.lightGrey),
  );
  final filter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  bool isReviewing = Services.shared.completed == "Yes";
  final licenseCategoryController = TextEditingController();
  @override
  initState() {
    super.initState();
    apicall();
  }

  apicall() async {
    setState(() => isLoading = true);
    await controller.getTempDrivingTestInfo();
    licenseCategoryController.text = controller.test.licenseCategory;
    setState(() => isLoading = false);
  }

  Widget smallText(String str) {
    return Text(str, style: MyFonts.regular(15));
  }

  Widget tableRow(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: smallText(text),
      ),
    );
  }

  Widget rowSelect(Widget title, Widget select) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: title,
        ),
        SizedBox(
          width: 100,
          child: select,
        )
      ],
    );
  }

  Widget labelText(String title, {Color? color}) =>
      Text(title, style: MyFonts.regular(16, color: color ?? MyColors.black));

  Widget getContent() {
    print(controller.test.driverName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        abTitle('Licence Category:'),
        SizedBox(height: 16),
        abTextField(controller.test.licenseCategory,
            (e) => controller.test.licenseCategory = e,
            hintText: '',
            validator: (e) => textValidate(e),
            readOnly: isReviewing,
            controller: licenseCategoryController),
        SizedBox(height: 16),
        abTitle('Date'),
        SizedBox(height: 16),
        abStatusButton(controller.licenseDateApp, null, () async {
          if (isReviewing) return;
          final now = getNow;
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: stringToDate(controller.licenseDateApp, true) ?? now,
            firstDate: now,
            lastDate: DateTime(now.year + 10),
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
          if (picked != null) {
            setState(() {
              controller.licenseDateApp = formatDate(picked);
              controller.test.licenseDate = dateToString(picked, true) ?? '';
            });
          }
        }, hideStatus: true),
        SizedBox(height: 16),
        smallText(controller.longTexts[1]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Maximum hours:'),
            abDropDownButtonFormField(
                controller.selected_maxDriHours, controller.selectData,
                (value) {
              setState(() {
                controller.test.maxDriHours = value.id;
                controller.selected_maxDriHours = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[2]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Break Minutes:'),
            abDropDownButtonFormField(
                controller.selected_breakMinutes, controller.selectData,
                (value) {
              setState(() {
                controller.test.breakMinutes = value.id;
                controller.selected_breakMinutes = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[3]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Replaced Break Minutes:'),
            abDropDownButtonFormField(
                controller.selected_repBreakMinutes, controller.selectData,
                (value) {
              setState(() {
                controller.test.repBreakMinutes = value.id;
                controller.selected_repBreakMinutes = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        rowSelect(
            labelText('Followed Break Minutes:'),
            abDropDownButtonFormField(
                controller.selected_folBreakMinutes, controller.selectData,
                (value) {
              setState(() {
                controller.test.folBreakMinutes = value.id;
                controller.selected_folBreakMinutes = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[4]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Daily Hours:'),
            abDropDownButtonFormField(
                controller.selected_dayHours, controller.selectData, (value) {
              setState(() {
                controller.test.dayHours = value.id;
                controller.selected_dayHours = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[5]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Number of Occasions:'),
            abDropDownButtonFormField(
                controller.selected_weekOcca, controller.selectData, (value) {
              setState(() {
                controller.test.weekOcca = value.id;
                controller.selected_weekOcca = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        rowSelect(
            labelText('Maximum Hours:'),
            abDropDownButtonFormField(
                controller.selected_maxHour, controller.selectData, (value) {
              setState(() {
                controller.test.maxHour = value.id;
                controller.selected_maxHour = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[6]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Maximum Hours:'),
            abDropDownButtonFormField(
                controller.selected_weekMaxHour, controller.selectData,
                (value) {
              setState(() {
                controller.test.weekMaxHour = value.id;
                controller.selected_weekMaxHour = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        rowSelect(
            labelText('Exceed Hours:'),
            abDropDownButtonFormField(
                controller.selected_exceedHour, controller.selectData, (value) {
              setState(() {
                controller.test.exceedHour = value.id;
                controller.selected_exceedHour = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            abTitle('      • '),
            Expanded(child: abTitle(controller.longTexts[7])),
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            abTitle('      • '),
            Expanded(child: abTitle(controller.longTexts[8])),
          ],
        ),
        SizedBox(height: 16),
        smallText(controller.longTexts[9]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Minimum Hours:'),
            abDropDownButtonFormField(
                controller.selected_dayMinHours, controller.selectData,
                (value) {
              setState(() {
                controller.test.dayMinHours = value.id;
                controller.selected_dayMinHours = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[10]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Minimum Hours:'),
            abDropDownButtonFormField(
                controller.selected_dayRestMinHours, controller.selectData,
                (value) {
              setState(() {
                controller.test.dayRestMinHours = value.id;
                controller.selected_dayRestMinHours = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        abTitle(controller.longTexts[11]),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            abTitle('      • '),
            Expanded(child: abTitle(controller.longTexts[12])),
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            abTitle('      • '),
            Expanded(child: abTitle(controller.longTexts[13])),
          ],
        ),
        SizedBox(height: 16),
        smallText(controller.longTexts[14]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Rest Hours:'),
            abDropDownButtonFormField(
                controller.selected_weekRestHour, controller.selectData,
                (value) {
              setState(() {
                controller.test.weekRestHour = value.id;
                controller.selected_weekRestHour = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        rowSelect(
            labelText('Reduced Rest Hours:'),
            abDropDownButtonFormField(
                controller.selected_weekRedRestHour, controller.selectData,
                (value) {
              setState(() {
                controller.test.weekRedRestHour = value.id;
                controller.selected_weekRedRestHour = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[15]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Training Hours:'),
            abDropDownButtonFormField(
                controller.selected_trainingHours, controller.selectData,
                (value) {
              setState(() {
                controller.test.trainingHours = value.id;
                controller.selected_trainingHours = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        abTitle(controller.longTexts[16]),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            abTitle('      • '),
            Expanded(child: abTitle(controller.longTexts[17])),
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            abTitle('      • '),
            Expanded(child: abTitle(controller.longTexts[18])),
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            abTitle('      • '),
            Expanded(child: abTitle(controller.longTexts[19])),
          ],
        ),
        SizedBox(height: 16),
        smallText(controller.longTexts[20]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Maximum Hours:'),
            abDropDownButtonFormField(
                controller.selected_maxHourLim, controller.selectData, (value) {
              setState(() {
                controller.test.maxHourLim = value.id;
                controller.selected_maxHourLim = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[21]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Minimum Break Minutes:'),
            abDropDownButtonFormField(
                controller.selected_minBreakMinutes, controller.selectData,
                (value) {
              setState(() {
                controller.test.minBreakMinutes = value.id;
                controller.selected_minBreakMinutes = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[22]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Total Break Minutes:'),
            abDropDownButtonFormField(
                controller.selected_totalBreakMin, controller.selectData,
                (value) {
              setState(() {
                controller.test.totalBreakMin = value.id;
                controller.selected_totalBreakMin = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[23]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Total Break Minutes:'),
            abDropDownButtonFormField(
                controller.selected_breakMin, controller.selectData, (value) {
              setState(() {
                controller.test.breakMin = value.id;
                controller.selected_breakMin = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[24]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Maximum Hours:'),
            abDropDownButtonFormField(
                controller.selected_totalHours, controller.selectData, (value) {
              setState(() {
                controller.test.totalHours = value.id;
                controller.selected_totalHours = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
        smallText(controller.longTexts[25]),
        SizedBox(height: 16),
        rowSelect(
            labelText('Maximum Hours:'),
            abDropDownButtonFormField(
                controller.selected_weekMaxHourLim, controller.selectData,
                (value) {
              setState(() {
                controller.test.weekMaxHourLim = value.id;
                controller.selected_weekMaxHourLim = value;
              });
              controller.validate();
            }, disable: isReviewing)),
        SizedBox(height: 16),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'dt'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        if (isReviewing) {
          await Resume.shared.setDone(name: 'DrivingTestView');
          if (isQuizTest && !is35T) {
            Get.bottomSheet(
              NewInfoView(7, () async {
                await localStorage?.setBool('isCompetencyTestCompleted', true);
                Get.to(() => CompetencyTest());
              }),
              enableDrag: false,
              isDismissible: false,
              isScrollControlled: true,
            );
          } else {
            await localStorage?.setBool('isCompetencyTestCompleted', true);
            Get.off(() => RegistrationView());
          }
          return;
        }
        if (controller.validated()) {
          setState(() => isLoading = true);
          final success = await controller.updateTempDrivingTestInfo();
          setState(() => isLoading = false);
          if (success) {
            await Resume.shared.setDone(name: 'DrivingTestView');
            await Services.shared
                .sendProgress('DrivingTestView'); // screen_id == 16
            if (isQuizTest && !is35T) {
              Get.bottomSheet(
                NewInfoView(7, () async {
                  Get.to(() => OnboardingWizard());
                }),
                enableDrag: false,
                isDismissible: false,
                isScrollControlled: true,
              );
            } else {
              await localStorage?.setBool('isCompetencyTestCompleted', true);
              Get.off(() => RegistrationView());
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldFormScrollView(
        context, isLoading, controller.drivingTest,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }

  textValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'enterText'.tr;
    }
    return null;
  }
}

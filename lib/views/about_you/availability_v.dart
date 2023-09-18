import 'package:extra_staff/controllers/about_you/availability_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/about_you/bank_details_v.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class Availability extends StatefulWidget {
  const Availability({Key? key}) : super(key: key);

  @override
  _AvailabilityState createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  final controller = AvailabilityController();

  Map<String, dynamic> allData = {};
  bool isLoading = false;
  final isNiUploaded = localStorage?.getBool('isNiUploaded') ?? false;
  bool isReviewing = Services.shared.completed == "Yes";
  final criminalDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.data = Get.arguments['aboutYou'];
    controller.dropDowns = Get.arguments['dropDowns'];
    allData = {'aboutYou': controller.data, 'dropDowns': controller.dropDowns};
    setData();
  }

  setData() async {
    await controller.setData();
    criminalDescController.text = controller.data.criminalDesc;
    if (!isNiUploaded) controller.data.nationalInsurance = '';

    setState(() {});
  }

  next(int i, bool showMessage) async {
    final error = controller.validate();
    if (error.isNotEmpty) {
      if (showMessage) {
        abShowMessage(error);
      }
      return;
    }
    if (i == 0) {
      if (isReviewing) {
        await Resume.shared.setDone(name: 'Availability');
        Get.to(() => BankDetails(), arguments: allData);
        return;
      }
      setState(() => isLoading = true);
      final message = await controller.updateTempInfo();
      setState(() => isLoading = false);
      if (message.isEmpty) {
        await localStorage?.setString('dob', controller.data.dob);
        await Resume.shared.setDone(name: 'Availability');
        await Services.shared.sendProgress('Availability'); // screen_id == 6
        Get.bottomSheet(
          NewInfoView(5, () {
            Get.to(() => BankDetails(), arguments: allData);
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

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        if (isNiUploaded) ...[
          abTitle('nationalInsurance'.tr),
          SizedBox(height: 8),
          abTextField(
              controller.data.nationalInsurance,
              (p0) => controller.data.nationalInsurance =
                  p0.replaceAll(' ', ''), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }, readOnly: isReviewing),
          SizedBox(height: 16),
        ],
        abTitle('dateOfBirth'.tr),
        SizedBox(height: 8),
        abStatusButton(controller.formatDateStr(), null, () async {
          if (isReviewing) return;
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: controller.selectedDob ?? maxDate,
            firstDate: minDate,
            lastDate: maxDate,
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
          if (picked != null && picked != controller.selectedDob) {
            setState(() {
              controller.selectedDob = picked;
              controller.setDate(picked);
            });
          }
        }, hideStatus: true),
        SizedBox(height: 16),
        abTitle('euNS'.tr),
        SizedBox(height: 8),
        abDropDownButton(controller.selectedEU, controller.dropDowns.euNational,
            (value) async {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            controller.data.euNational = value.id;
            controller.selectedEU = value;
          });
        }, disable: isReviewing),
        SizedBox(height: 16),
        abTitle('employemntStatus'.tr),
        SizedBox(height: 8),
        abDropDownButton(controller.selectedES, controller.esValues, (v) {
          setState(() {
            controller.data.contract = v.id;
            controller.selectedES = v;
          });
        }, disable: isReviewing),
        SizedBox(height: 16),
        abTitle('hasCriminalConvictions'.tr),
        SizedBox(height: 16),
        abRadioButtons(controller.hasCriminalConvictions, (b) {
          if (isReviewing) return;
          setState(() {
            controller.data.criminal = b! ? '1' : '2';
            if (controller.data.criminal == "2") {
              criminalDescController.text = "";
              controller.data.criminalDesc = "";
            }
            controller.hasCriminalConvictions = b;
          });
        }, showIcon: true),
        SizedBox(height: 16),
        abTitle('If yes, please give further details'),
        SizedBox(height: 8),
        abTextField(controller.data.criminalDesc,
            (p0) => controller.data.criminalDesc = p0, validator: (value) {
          if (controller.data.criminal == '1' &&
              (value == null || value.isEmpty)) {
            return 'enterText'.tr;
          }
          return null;
        },
            maxLines: 4,
            maxLength: 1024,
            controller: criminalDescController,
            readOnly: isReviewing || (controller.data.criminal == "2")),
        SizedBox(height: 16),
        abTitle('emergencyContactName'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.emergencyContact, (text) {
          controller.data.emergencyContact = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          return null;
        }, readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('emergencyContactTelephoneNumber'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.emergencyContactNumber, (text) {
          controller.data.emergencyContactNumber = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          } else if (!isPhoneNo(value)) {
            return 'validPhone'.tr;
          }
          return null;
        },
            keyboardType: TextInputType.number,
            maxLength: 11,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            readOnly: isReviewing),
        SizedBox(height: 16),
        abTitle('emergencyContactRelationship'.tr),
        SizedBox(height: 8),
        abDropDownButton(
            controller.selectedRelationship, controller.contactRelationship,
            (value) async {
          setState(() {
            controller.data.emergencyContactRelationship = value.id;
          });
          await next(0, false);
        }, disable: isReviewing),
        SizedBox(height: 16),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'aboutYou'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      await next(i, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldFormScrollView(
        context, isLoading, controller.formKey,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }
}

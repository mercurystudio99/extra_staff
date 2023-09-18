import 'package:extra_staff/controllers/about_you/address_c.dart';
import 'package:extra_staff/models/address_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/about_you/availability_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final controller = AddressController();
  Map<String, dynamic> allData = {};
  bool isLoading = false;
  bool isReviewing = Services.shared.completed == "Yes";

  final addressPostCodeController = TextEditingController();
  final address_1Controller = TextEditingController();
  final address_2Controller = TextEditingController();
  final addressTownController = TextEditingController();
  final addressCountyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.data = Get.arguments['aboutYou'];
    controller.dropDowns = Get.arguments['dropDowns'];
    allData = {'aboutYou': controller.data, 'dropDowns': controller.dropDowns};
    addressPostCodeController.text = controller.data.addressPostCode;
    address_1Controller.text = controller.data.address_1;
    address_2Controller.text = controller.data.address_2;
    addressTownController.text = controller.data.addressTown;
    addressCountyController.text = controller.data.addressCounty;
    setState(() {});
  }

  Widget searchAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        abTitle('searchByPostcode'.tr),
        SizedBox(height: 8),
        abTextField(controller.searchByPostcode, (text) {
          controller.searchByPostcode = text;
        }, readOnly: isReviewing),
        SizedBox(height: 16),
        abSimpleButton('findAddress'.tr, onTap: () async {
          if (isReviewing) return;
          if (controller.searchByPostcode.isEmpty) {
            abShowMessage('postcodeNotFound'.tr);
            return;
          }
          setState(() => isLoading = true);
          controller.allAddresses =
              await Services.shared.getAddress(controller.searchByPostcode);
          if (controller.allAddresses.isNotEmpty) {
            controller.selectedAddress = controller.allAddresses.first;
          }
          setState(() => isLoading = false);
        }),
        SizedBox(height: 16),
        if (controller.allAddresses.isNotEmpty)
          Container(
            height: buttonHeight,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: abOutline(borderColor: MyColors.darkBlue),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                icon: RotatedBox(
                  quarterTurns: 1,
                  child:
                      Icon(Icons.arrow_forward_ios, color: MyColors.darkBlue),
                ),
                value: controller.selectedAddress,
                onChanged: (AddressModel? newValue) async {
                  if (newValue != null) {
                    setState(() => isLoading = true);
                    controller.setValues(newValue);
                    addressPostCodeController.text =
                        controller.data.addressPostCode;
                    address_1Controller.text = controller.data.address_1;
                    address_2Controller.text = controller.data.address_2;
                    addressTownController.text = controller.data.addressTown;
                    addressCountyController.text =
                        controller.data.addressCounty;
                    setState(() {
                      isLoading = false;
                    });
                    // Future.delayed(
                    //   duration,
                    //   () => setState(() => isLoading = false),
                    // );
                  }
                },
                items: controller.allAddresses
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value.fullAddress(),
                            style: MyFonts.regular(17, color: MyColors.black),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        searchAddress(),
        SizedBox(height: 16),
        abTitle('postcode'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.addressPostCode, (text) {
          controller.data.addressPostCode = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          return null;
        }, readOnly: isReviewing, controller: addressPostCodeController),
        SizedBox(height: 16),
        abTitle('addressLine1'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.address_1, (text) {
          controller.data.address_1 = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          return null;
        }, readOnly: isReviewing, controller: address_1Controller),
        SizedBox(height: 16),
        abTitle('addressLine2'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.address_2, (text) {
          controller.data.address_2 = text;
        }, readOnly: isReviewing, controller: address_2Controller),
        SizedBox(height: 16),
        abTitle('town'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.addressTown, (text) {
          controller.data.addressTown = text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterText'.tr;
          }
          return null;
        }, readOnly: isReviewing, controller: addressTownController),
        SizedBox(height: 16),
        abTitle('county'.tr),
        SizedBox(height: 8),
        abTextField(controller.data.addressCounty, (text) {
          controller.data.addressCounty = text;
        },
            onFieldSubmitted: (e) async => await next(),
            readOnly: isReviewing,
            controller: addressCountyController),
        SizedBox(height: 16),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'aboutYou'.tr);
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (i) async {
      if (i == 0) {
        if (!controller.formKey.currentState!.validate()) {
          return 'error'.tr;
        } else {
          await next();
        }
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
      await Resume.shared.setDone(name: 'Address');
      Get.to(() => Availability(), arguments: allData);
      return;
    }
    setState(() => isLoading = true);
    final message = await controller.updateTempInfo();
    setState(() => isLoading = false);
    if (message.isEmpty) {
      await Resume.shared.setDone(name: 'Address');
      await Services.shared.sendProgress('Address'); // screen_id == 5
      Get.to(() => Availability(), arguments: allData);
    } else {
      abShowMessage(message);
    }
  }
}

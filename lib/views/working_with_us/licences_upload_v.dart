import 'package:extra_staff/controllers/working_with_us/licences_upload_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/working_with_us/availability2_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:extra_staff/views/registration_progress_v.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';

class LicencesUploadView extends StatefulWidget {
  const LicencesUploadView({Key? key}) : super(key: key);

  @override
  _LicencesUploadViewState createState() => _LicencesUploadViewState();
}

class _LicencesUploadViewState extends State<LicencesUploadView> {
  Map<String, dynamic> allData = {};
  final controller = LicencesUploadController();
  final ImagePicker picker = ImagePicker();
  VideoPlayerController? _controller;
  bool isVisiable = false;
  bool isLoading = false;
  bool isReviewing = Services.shared.completed == "Yes";
  @override
  void initState() {
    super.initState();
    controller.data = Get.arguments['aboutYou'];
    controller.dropDowns = Get.arguments['dropDowns'];
    allData = {'aboutYou': controller.data, 'dropDowns': controller.dropDowns};
    controller.getDataFromStorage();
    setData();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller =
        VideoPlayerController.asset('lib/images/How2DrivingLicence.mp4');
    _controller!.initialize().then((_) {
      initialize();
    });
  }

  initialize() async {
    Future.delayed(duration, () {
      setState(() {
        _controller!.play();
      });
    });
  }

  setData() async {
    setState(() => isLoading = true);
    await controller.getCountryDropdownInfo();
    await controller.getTempLicenseInfo();
    setState(() => isLoading = false);
  }

  Widget licence(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
    );
  }

  Widget getContent() {
    final isUploadedF = controller.isUploaded(true);
    final isUploadedB = controller.isUploaded(false);
    final firstF = isUploadedF ? 'retakePhoto'.tr : 'useCamera'.tr;
    final secondF = isUploadedF ? 'uploadNewPhoto'.tr : 'gallery'.tr;
    final firstB = isUploadedB ? 'retakePhoto'.tr : 'useCamera'.tr;
    final secondB = isUploadedB ? 'uploadNewPhoto'.tr : 'gallery'.tr;
    final backgroundF = isUploadedF ? MyColors.green : null;
    final backgroundB = isUploadedB ? MyColors.green : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 240.0,
          ),
          child: Center(
            child: AspectRatio(
              aspectRatio: 192 / 108,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() => isVisiable = true);
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() => isVisiable = false);
                      });
                    },
                    child: VideoPlayer(_controller!),
                  ),
                  Visibility(
                    visible: isVisiable,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: MyColors.black.withAlpha(50),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: MyColors.darkBlue,
                          size: 50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        abTitle('${controller.title} - Front'),
        SizedBox(height: 16),
        if (!isWebApp) ...[
          abSimpleButton(firstF, onTap: () async {
            if (!isReviewing) await getImageFrom(ImageSource.camera, 0);
          }, backgroundColor: backgroundF),
          SizedBox(height: 16),
        ],
        abSimpleButton(secondF, onTap: () async {
          if (!isReviewing) await getImageFrom(ImageSource.gallery, 0);
        }, backgroundColor: backgroundF),
        SizedBox(height: 16),
        abTitle('${controller.title} - Back'),
        SizedBox(height: 16),
        if (!isWebApp) ...[
          abSimpleButton(firstB, onTap: () async {
            if (!isReviewing) await getImageFrom(ImageSource.camera, 1);
          }, backgroundColor: backgroundB),
          SizedBox(height: 16),
        ],
        abSimpleButton(secondB, onTap: () async {
          if (!isReviewing) await getImageFrom(ImageSource.gallery, 1);
        }, backgroundColor: backgroundB),
        SizedBox(height: 16),
        if (controller.type == LicenceType.licence) ...[
          SizedBox(height: 16),
          abTitle('Driving licence Passed date'),
          SizedBox(height: 16),
          abStatusButton(
              dateToString(controller.passDate, false) ?? 'dd/mm/yyyy', null,
              () async {
            if (isReviewing) return;
            final now = getNow;
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.passDate ?? now,
              firstDate: DateTime(now.year - 10),
              lastDate: now,
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light().copyWith(
                      primary: MyColors
                          .darkBlue, // Customize the selected color here
                    ),
                  ),
                  child: child!,
                );
              },
            );
            setState(() {
              controller.passDate = picked;
              controller.drivingIssueDate = dateToString(picked, true) ?? '';
            });
          }, hideStatus: true),
          SizedBox(height: 16),
        ],
        abTitle('${controller.title} Expiry Date'),
        SizedBox(height: 16),
        abStatusButton(
            dateToString(controller.expDate, false) ?? 'dd/mm/yyyy', null,
            () async {
          if (isReviewing) return;
          final now = getNow;
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: controller.expDate ?? now,
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
          setState(() {
            controller.expDate = picked;
            switch (controller.type) {
              case LicenceType.licence:
                controller.drivingDateExpiry = dateToString(picked, true) ?? '';
                return;
              case LicenceType.tacho:
                controller.tachoDateExpiry = dateToString(picked, true) ?? '';
                return;
              case LicenceType.qualification:
                controller.digicardDateExpiry =
                    dateToString(picked, true) ?? '';
                return;
            }
          });
        }, hideStatus: true),
        SizedBox(height: 16),
        if (controller.type != LicenceType.licence) ...[
          abTitle('Country of Issue'),
          SizedBox(height: 16),
          abDropDownButton(
              controller.selectedCountry, controller.countryOptions, (e) {
            setState(() {
              controller.selectedCountry = e;
              switch (controller.type) {
                case LicenceType.licence:
                  return;
                case LicenceType.tacho:
                  controller.tachoCountry = controller.selectedCountry.value;
                  return;
                case LicenceType.qualification:
                  controller.digicardCountry = controller.selectedCountry.value;
                  return;
              }
            });
          }, disable: isReviewing),
          SizedBox(height: 16),
        ],
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, controller.title, onTap: (i) async {
      if (i == 1) {
        //back button
        final isChanged = controller.changeTypeOnBack();
        if (isChanged) await setData();
      } else {
        //home button
        if (isReviewing)
          Get.offAll(() => RegistrationComplete());
        else
          Get.offAll(() => RegistrationProgress());
      }
    });
  }

  Widget getBottomBar() {
    return abBottomNew(context, onTap: (e) async {
      if (e == 0) {
        if (controller.isWorking == false) {
          controller.isWorking = true;
          next(true);
          controller.isWorking = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldScrollView(
        context, isLoading,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }

  next(bool showError) async {
    if (isReviewing) {
      await controller.changeType();
      setState(() {});
      if (controller.allFinished) {
        await Resume.shared.setDone(name: 'LicencesUploadView');
        Get.to(() => Availability2(), arguments: allData);
      }
      return;
    }
    final str = controller.validate();
    if (str.isNotEmpty) {
      abShowMessage(str);
      return;
    }
    if (!controller.isCompleted) {
      if (showError) abShowMessage('uploadAllDocuments'.tr);
      return;
    }
    setState(() => isLoading = true);
    final message = await controller.updateTempLicenseAdditionalInfo();
    setState(() => isLoading = false);
    if (message.isNotEmpty) {
      abShowMessage(message);
    }
    await controller.changeType();
    setState(() {});
    if (controller.allFinished) {
      await Resume.shared.setDone(name: 'LicencesUploadView');
      await Services.shared
          .sendProgress('LicencesUploadView'); // screen_id == 14
      Get.to(() => Availability2(), arguments: allData);
    }
  }

  getImageFrom(ImageSource source, int index) async {
    try {
      if (index == 0) {
        controller.front = await picker.pickImage(source: source);
      } else {
        controller.back = await picker.pickImage(source: source);
      }
      setState(() => isLoading = true);
      final message = await controller.uploadImages(index);
      await controller.getTempLicenseInfo();
      setState(() => isLoading = false);
      if (message.isNotEmpty) {
        if (index == 0) {
          controller.front = null;
        } else {
          controller.back = null;
        }
        abShowMessage(message);
      }
    } catch (error) {
      print(error.toString());
      setState(() => isLoading = false);
    }
  }
}

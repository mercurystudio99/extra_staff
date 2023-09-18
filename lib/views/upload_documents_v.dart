import 'package:extra_staff/controllers/list_to_upload_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/analysing_docs.v.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:video_player/video_player.dart';
import 'package:extra_staff/utils/services.dart';

class UploadDocumentsView extends StatefulWidget {
  final ListToUploadController controller;
  const UploadDocumentsView({required this.controller});

  @override
  _UploadDocumentsViewState createState() =>
      _UploadDocumentsViewState(controller: controller);
}

class _UploadDocumentsViewState extends State<UploadDocumentsView> {
  _UploadDocumentsViewState({required this.controller});

  ListToUploadController controller;
  final scrollController = ScrollController();
  bool isLoading = false;
  var isCompleted = [false, false];
  final ImagePicker picker = ImagePicker();
  VideoPlayerController? _controller;
  bool isVisiable = false;
  bool isPdfOrDocSelected = false;

  @override
  void initState() {
    super.initState();

    controller.isCV = Get.arguments?['isCV'] ?? false;
    controller.isForklift = Get.arguments?['isForklift'] ?? false;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset(controller.videoToPlay);
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

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  Widget words(int index) {
    final isDriving = controller.type.value == 'drivinglicence'.tr;
    if (index == 0) {
      if (isDriving) {
        return abWords('frontDriving'.tr, 'frontDrivingH'.tr, null);
      } else {
        return abWords('frontVisaBrp'.tr, 'frontVisaBrpH'.tr, null);
      }
    } else {
      if (isDriving) {
        return abWords('backDriving'.tr, 'backDrivingH'.tr, null);
      } else {
        return abWords('backVisaBrp'.tr, 'backVisaBrpH'.tr, null);
      }
    }
  }

  Widget documentContent(int index) {
    final upload = controller.isCV
        ? 'CV'
        : controller.isForklift
            ? 'Forklift licence'
            : controller.type.value;
    final isUploaded = isCompleted[index];
    final backColor = isPdfOrDocSelected
        ? null
        : isUploaded
            ? MyColors.green
            : null;
    final first = isUploaded ? 'retakePhoto'.tr : 'useCamera'.tr;
    final second = isUploaded ? 'uploadNewPhoto'.tr : 'gallery'.tr;
    return Column(
      children: [
        controller.isSingleImage()
            ? abWords('upload'.tr + ' ' + upload, upload, null)
            : words(index),
        SizedBox(height: 32),
        if (controller.isSingleImage()) SizedBox(height: 32),
        if (!isWebApp) ...[
          abSimpleButton(
            first.toUpperCase(),
            onTap: () async => getImageFrom(ImageSource.camera, index),
            backgroundColor: backColor,
          ),
          SizedBox(height: 16),
        ],
        abSimpleButton(
          second.toUpperCase(),
          onTap: () async => getImageFrom(ImageSource.gallery, index),
          backgroundColor: backColor,
        ),
        SizedBox(height: 32),
      ],
    );
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        controller.isCV || controller.isForklift
            ? Icon(
                Icons.upload_file_sharp,
                color: MyColors.darkBlue,
                size: 125,
              )
            : ConstrainedBox(
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
        SizedBox(height: 32),
        documentContent(0),
        if (!controller.isSingleImage()) ...[
          Divider(thickness: 2, color: MyColors.offWhite),
          SizedBox(height: 32),
          documentContent(1),
        ],
        if (controller.isCV) ...[
          openFilesForCV(),
          SizedBox(height: 32),
        ],
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'Upload'.tr);
  }

  Widget getBottomBar() {
    String buttonText = 'skip'.tr;
    if (Services.shared.completed == "Yes") {
      buttonText = 'done'.tr;
    }
    return abBottomNew(
      context,
      top: controller.isCV || controller.isForklift ? buttonText : null,
      onTap: (e) {
        if (e == 0) {
          Get.back(result: true);
        }
      },
    );
  }

  Widget getMainWidgetWithBottomBarLoadingOverlayScaffoldScrollView(
      BuildContext context, bool isLoading,
      {required PreferredSizeWidget appBar,
      required Widget content,
      Widget? bottomBar}) {
    if (isWebApp) {
      return LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors
              .darkBlue), // set the background color of the loading circle
        ),
        child: Scaffold(
          appBar: appBar,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: gHPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: content),
                      ),
                      if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                    ],
                  ),
                ),
              ),
              if (bottomBar != null) bottomBar
            ],
          ),
        ),
      );
    } else {
      return LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors
              .darkBlue), // set the background color of the loading circle
        ),
        child: Scaffold(
          appBar: appBar,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                    controller: scrollController,
                    padding: gHPadding,
                    child: content),
              ),
              if (bottomBar != null) bottomBar
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getMainWidgetWithBottomBarLoadingOverlayScaffoldScrollView(
        context, isLoading,
        appBar: getAppBar(), content: getContent(), bottomBar: getBottomBar());
  }

  Widget openFilesForCV() {
    return abSimpleButton(
      'Add PDF or DOC',
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'docx'],
        );
        setState(() => isPdfOrDocSelected = result != null);
        if (result != null) {
          if (isWebApp)
            controller.image = XFile.fromData(result.files.single.bytes!);
          else
            controller.image = XFile(result.files.single.path!);
          await getImageFrom(ImageSource.camera, 0, isDoc: true);
        } else {
          print('User canceled the picker');
        }
      },
      backgroundColor: isPdfOrDocSelected ? MyColors.green : null,
    );
  }

  getImageFrom(ImageSource source, int index, {bool? isDoc}) async {
    try {
      if (isDoc != true) {
        controller.image = await picker.pickImage(source: source);
      }
      if (controller.image == null) {
        return;
      }

      isCompleted[index] = true;
      controller.isBack = index != 0;
      setState(() => isLoading = true);
      final message = await controller.uploadImages();
      setState(() => isLoading = false);
      if (!controller.isSingleImage() && isCompleted[index] == true) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: duration, curve: Curves.ease);
      }
      if (controller.isSingleImage() && isCompleted.first ||
          (!controller.isSingleImage() &&
              isCompleted.first &&
              isCompleted.last)) {
        await Resume.shared.setDone(name: 'UploadDocumentsView');
        if (controller.showAnalyzer) {
          await Get.to(() => AnalysingDocs(seconds: Duration(seconds: 6)));
          Future.delayed(duration * 2, () {
            Get.back(result: message == '');
          });
        } else {
          Get.back(result: message == '');
        }
      }
    } catch (error) {
      print(error.toString());
      setState(() => isLoading = false);
    }
  }
}

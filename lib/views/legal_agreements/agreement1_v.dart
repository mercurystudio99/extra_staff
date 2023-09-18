import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/agreements_v.dart';
import 'package:extra_staff/views/legal_agreements/user_confirmation_v.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/controllers/legal_agreements/agreements_c.dart';
import 'package:extra_staff/utils/services.dart';

class Agreement1 extends StatefulWidget {
  const Agreement1({Key? key}) : super(key: key);

  @override
  _Agreement1State createState() => _Agreement1State();
}

class _Agreement1State extends State<Agreement1> {
  final scrollController = ScrollController();
  late final AgreementsController controller;
  bool isLoading = true;
  bool needToScrolled = true;
  bool isReviewing = Services.shared.completed == "Yes";

  @override
  void initState() {
    super.initState();
    controller = Get.arguments;
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0 &&
          needToScrolled) {
        setState(() => needToScrolled = false);
      }
    });
    apiCall();
  }

  Future<bool> apiCall() async {
    setState(() => isLoading = true);
    final message = await controller.getAgreementInfo();
    setState(() => isLoading = false);
    if (message.isNotEmpty) {
      abShowMessage(message);
      return false;
    }
    return true;
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(gHPadding.left, 16, gHPadding.right, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('Dear $userName', style: MyFonts.semiBold(24)),
              ),
              InkWell(
                onTap: () {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: duration,
                    curve: Curves.elasticOut,
                  );
                  setState(() => needToScrolled = false);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.arrow_forward_ios, color: MyColors.white),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.darkBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: gHPadding,
            child: RawScrollbar(
              thumbVisibility: true,
              controller: scrollController,
              thumbColor: MyColors.darkBlue,
              radius: Radius.circular(16),
              thickness: 16,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Html(data: controller.txt),
              ),
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(
        context, controller.allAgreements[controller.currentIndex - 1].value);
  }

  Widget getBottomBar() {
    return abBottomNew(
      context,
      top: isReviewing ? null : 'agree'.tr,
      onlyTopDisabled: needToScrolled ? needToScrolled : null,
      onTap: (i) async {
        if (i == 0) {
          if (needToScrolled) {
            abShowMessage(
                'Scroll to bottom of document using right hand side down arrow to review before agreeing');
            return;
          }
          final message = await controller.updateTempAgreementInfo();
          if (message.isNotEmpty) {
            abShowMessage(message);
            return;
          }
          if (controller.currentIndex == controller.allAgreements.length) {
            await Resume.shared.setDone(name: 'Agreement1');
            await Resume.shared.setDone(name: 'AgreementsView');
            await Services.shared
                .sendProgress('AgreementsView'); // screen_id == 21

            final message = await controller.getTempAgreementInfo();
            if (message.isNotEmpty) {
              abShowMessage(message);
              return;
            }

            if (controller.allAccepted()) {
              Get.to(() => UserConfirmationView());
              return;
            } else {
              Get.to(() => AgreementsView());
              abShowMessage(
                  "We are unable to generate document. Please try again. If problem persist then please contact Extrastaff support.");
              return;
            }
          }
          controller.nextAgreement();
          final value = await apiCall();
          if (!value) return;
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: duration,
            curve: Curves.elasticOut,
          );
          setState(() => needToScrolled = true);
        }
      },
    );
  }

  Widget getBottomTitle() {
    if (isWebApp) {
      return Container(
          color: MyColors.darkBlue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Container(
                  padding: gHPadding,
                  color: MyColors.darkBlue,
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      abWords(
                        '${'dear'.tr} $userName ${'confirm'.tr}, ${'agreementAbove'.tr}',
                        '$userName ${'understood'.tr}',
                        null,
                        textColor: MyColors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
            ],
          ));
    } else {
      return Container(
        padding: gHPadding,
        color: MyColors.darkBlue,
        child: Column(
          children: [
            SizedBox(height: 16),
            abWords(
              '${'dear'.tr} $userName ${'confirm'.tr}, ${'agreementAbove'.tr}',
              '$userName ${'understood'.tr}',
              null,
              textColor: MyColors.white,
              size: 20,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return abMainWidgetWithBottomBarLoadingOverlayScaffoldBottomTitle(
        context, isLoading,
        appBar: getAppBar(),
        content: getContent(),
        bottomTitle: getBottomTitle(),
        bottomBar: getBottomBar());
  }
}

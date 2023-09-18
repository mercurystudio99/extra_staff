import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/login_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  Widget getContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isWebApp) SizedBox(height: 32),
        abSimpleButton(
          'signIn'.tr.toUpperCase(),
          onTap: () => Get.to(() => LoginView(), arguments: false),
        ),
        SizedBox(height: 32),
        abSimpleButton(
          'signUp'.tr.toUpperCase(),
          onTap: () => Get.to(() => LoginView(), arguments: true),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abHeaderNew(context, 'welcome'.tr, showHome: false);
  }

  Widget getBottomBar() {
    return abBottomNew(context, top: null);
  }

  @override
  Widget build(BuildContext context) {
    if (isWebApp) {
      return Scaffold(
        appBar: getAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Container(
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
                        child: getContent()),
                  ),
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                ],
              ),
            ),
            Spacer(),
            getBottomBar()
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: getAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Container(padding: gHPadding, child: getContent()),
            Spacer(),
            getBottomBar()
          ],
        ),
      );
    }
  }
}

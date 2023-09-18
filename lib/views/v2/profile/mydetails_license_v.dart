import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/views/v2/profile/icences_upload_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class V2ProfileLicenseView extends StatefulWidget {
  const V2ProfileLicenseView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsViewState createState() => _V2ProfileMyDetailsViewState();
}

class _V2ProfileMyDetailsViewState extends State<V2ProfileLicenseView> {
  MyThemeColors get _myThemeColors =>
      Theme.of(context).extension<MyThemeColors>()!;
  bool _isLoading = false;
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    abV2GotoBottomNavigation(index, 2);
  }

  Widget getContent() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 24),
            abV2PrimaryButton('Driving License Front',
                onTap: () => {Get.to(() => V2ProfileLicencesUploadView())},
                fullWidth: true),
            SizedBox(height: 20),
            abV2PrimaryButton('Driving License Back',
                onTap: () => {Get.to(() => V2ProfileLicencesUploadView())},
                fullWidth: true),
            SizedBox(height: 20),
            abV2PrimaryButton('Driver Qualifiation Card',
                onTap: () => {Get.to(() => V2ProfileLicencesUploadView())},
                fullWidth: true),
            SizedBox(height: 20),
            abV2PrimaryButton('Tacho card',
                onTap: () => {Get.to(() => V2ProfileLicencesUploadView())},
                fullWidth: true),
          ],
        ));
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, '', showBack: true);
  }

  @override
  Widget build(BuildContext context) {
    return abV2MainWidgetWithLoadingOverlayScaffoldScrollView(
        context, _isLoading,
        appBar: getAppBar(),
        content: getContent(),
        bottomNavigationBar:
            abV2BottomNavigationBarA(_selectedIndex, _onItemTapped));
  }
}

import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/views/v2/profile/mydetails_NI_v.dart';
import 'package:extra_staff/views/v2/profile/mydetails_address_v.dart';
import 'package:extra_staff/views/v2/profile/mydetails_details_v.dart';
import 'package:extra_staff/views/v2/profile/mydetails_rtw_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class V2ProfileMyDetailsMyDetailsView extends StatefulWidget {
  const V2ProfileMyDetailsMyDetailsView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsViewState createState() => _V2ProfileMyDetailsViewState();
}

class _V2ProfileMyDetailsViewState
    extends State<V2ProfileMyDetailsMyDetailsView> {
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
            abV2PrimaryButton('RTW',
                onTap: () => {Get.to(() => V2ProfileRTWView())},
                fullWidth: true),
            SizedBox(height: 13),
            abV2PrimaryButton('License',
                onTap: () => {Get.to(() => V2ProfileMyDetailsAddressView())},
                fullWidth: true),
            SizedBox(height: 13),
            abV2PrimaryButton('NI',
                onTap: () => {Get.to(() => V2ProfileNIView())},
                fullWidth: true),
            SizedBox(height: 13),
            abV2OutlineButton('Details that dont require approval',
                onTap: () => {Get.to(() => V2ProfileMyDetailsSubDetailsView())},
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

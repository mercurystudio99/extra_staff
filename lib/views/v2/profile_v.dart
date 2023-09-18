import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/views/v2/profile/holidayavailability_v.dart';
import 'package:extra_staff/views/v2/profile/mydetails_v.dart';
import 'package:extra_staff/views/v2/profile/payments_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class V2ProfileView extends StatefulWidget {
  const V2ProfileView({Key? key}) : super(key: key);

  @override
  _V2ProfileViewState createState() => _V2ProfileViewState();
}

class _V2ProfileViewState extends State<V2ProfileView> {
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
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            abV2PrimaryButton('PAYMENTS',
                onTap: () => {Get.to(() => V2ProfilePaymentsView())},
                fullWidth: true),
            SizedBox(height: 21),
            abV2PrimaryButton('MY DETAILS',
                onTap: () => {Get.to(() => V2ProfileMyDetailsView())},
                fullWidth: true),
            SizedBox(height: 21),
            abV2PrimaryButton('HOLIDAY/AVAILABILITY',
                onTap: () => {Get.to(() => V2ProfileHolidayAvailabilityView())},
                fullWidth: true),
          ],
        ));
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, 'v2_profile_view_appbar_title'.tr);
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

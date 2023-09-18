import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';
import 'icences_upload_v.dart';
import 'my_details_license_reupload_v.dart';

class V2ProfileMyDetailsAddressView extends StatefulWidget {
  const V2ProfileMyDetailsAddressView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsSubDetailsViewState createState() =>
      _V2ProfileMyDetailsSubDetailsViewState();
}

class _V2ProfileMyDetailsSubDetailsViewState
    extends State<V2ProfileMyDetailsAddressView> {
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
          SizedBox(height: 24),
          Container(
            child: abV2PrimaryButton(
              'v2_button_text_re_upload'.tr,
              onTap: () =>
                  {Get.to(() => V2ProfilemydetailsLicencesUploadView())},
              fullWidth: true,
            ),
          ),
          SizedBox(height: 24),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Search by postcode',
                    style: TextStyle(fontSize: 16, color: MyColors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(fontSize: 16, color: MyColors.black),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2))),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Postcode',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextFormField(
            style: TextStyle(fontSize: 16, color: MyColors.black),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCBD6E2)),
              ),
              suffixIcon: MouseRegion(
                cursor: SystemMouseCursors.click, // change cursor to pointer
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Add your logic for handling the password edit here
                  },
                  color: Color(0xFF748A9D),
                ),
              ),
            ),
            enabled:
                false, // Set enabled to false to make the input box not editable
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Address Line1',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextFormField(
            style: TextStyle(fontSize: 16, color: MyColors.black),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCBD6E2)),
              ),
              suffixIcon: MouseRegion(
                cursor: SystemMouseCursors.click, // change cursor to pointer
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Add your logic for handling the password edit here
                  },
                  color: Color(0xFF748A9D),
                ),
              ),
            ),
            enabled:
                false, // Set enabled to false to make the input box not editable
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Address Line 2',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextFormField(
            style: TextStyle(fontSize: 16, color: MyColors.black),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCBD6E2)),
              ),
              suffixIcon: MouseRegion(
                cursor: SystemMouseCursors.click, // change cursor to pointer
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Add your logic for handling the password edit here
                  },
                  color: Color(0xFF748A9D),
                ),
              ),
            ),
            enabled:
                false, // Set enabled to false to make the input box not editable
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Town',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextFormField(
            style: TextStyle(fontSize: 16, color: MyColors.black),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCBD6E2)),
              ),
              suffixIcon: MouseRegion(
                cursor: SystemMouseCursors.click, // change cursor to pointer
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Add your logic for handling the password edit here
                  },
                  color: Color(0xFF748A9D),
                ),
              ),
            ),
            enabled:
                false, // Set enabled to false to make the input box not editable
          ),
        ],
      ),
    );
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

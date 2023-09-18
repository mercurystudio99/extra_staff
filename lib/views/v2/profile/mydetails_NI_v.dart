import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/v2/profile/validate_account_in_v.dart';
import 'package:extra_staff/views/v2/profile/validate_account_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class V2ProfileNIView extends StatefulWidget {
  const V2ProfileNIView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsViewState createState() => _V2ProfileMyDetailsViewState();
}

class _V2ProfileMyDetailsViewState extends State<V2ProfileNIView> {
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
          // SizedBox(height: 20),
          Text(
            'NI',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              color: Color(0xFF00458D),
            ),
          ),
          SizedBox(height: 28),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 322,
              height: 322,
              child: SvgPicture.asset(
                "lib/images/v2/qr.svg",
              ),
            ),
          ),
          SizedBox(height: 27),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'NI',
                    style: TextStyle(fontSize: 16, color: MyColors.grey),
                  ),
                ],
              ),
              SizedBox(height: 3),
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
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Container(
                  // margin: const EdgeInsets.all(10),
                  width: 0.5,
                  child: abV2PrimaryButton(
                    'v2_button_text_cancel'.tr,
                    onTap: () => {},
                    fullWidth: true,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  // margin: const EdgeInsets.all(10),
                  width: 0.5,
                  child: abV2PrimaryButton(
                    'v2_button_text_re_upload'.tr,
                    onTap: () =>
                        {Get.to(() => V2ProfileValidateAccountViewIN())},
                    fullWidth: true,
                  ),
                ),
              ),
            ],
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

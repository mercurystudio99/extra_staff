import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/views/v2/profile/validate_account_rtw_v.dart';
import 'package:extra_staff/views/v2/profile/validate_account_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class V2ProfileRTWView extends StatefulWidget {
  const V2ProfileRTWView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsViewState createState() => _V2ProfileMyDetailsViewState();
}

class _V2ProfileMyDetailsViewState extends State<V2ProfileRTWView> {
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
            'RTW',
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
          SizedBox(height: 21),
          Row(
            children: [
              Expanded(
                child: Container(
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
                  width: 0.5,
                  child: abV2PrimaryButton(
                    'v2_button_text_re_upload'.tr,
                    onTap: () => {
                      Get.to(() => V2ProfileValidateAccountViewRTW()),
                    },
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

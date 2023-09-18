import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../utils/theme.dart';

class V2ProfileMyDetailsInfoView extends StatefulWidget {
  const V2ProfileMyDetailsInfoView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsInfoViewState createState() =>
      _V2ProfileMyDetailsInfoViewState();
}

class _V2ProfileMyDetailsInfoViewState
    extends State<V2ProfileMyDetailsInfoView> {
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
            Text(
              'Profile/My Details/Details That don\'t require Approval',
              style: MyFonts.regular(20, color: _myThemeColors.primary),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, 'Info', showBack: true);
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

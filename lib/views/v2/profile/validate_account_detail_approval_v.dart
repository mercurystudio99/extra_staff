import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class V2ProfileValidateAccountViewdetailApproval extends StatefulWidget {
  const V2ProfileValidateAccountViewdetailApproval({Key? key})
      : super(key: key);

  @override
  _V2ProfileValidateAccountViewdetailApprovalState createState() =>
      _V2ProfileValidateAccountViewdetailApprovalState();
}

class _V2ProfileValidateAccountViewdetailApprovalState
    extends State<V2ProfileValidateAccountViewdetailApproval> {
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
            SizedBox(height: 15),
            Text(
              'v2_validate_account'.tr,
              style: MyFonts.regular(20, color: _myThemeColors.primary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            SvgPicture.asset("lib/images/v2/authorization.svg",
                width: 64, height: 64),
            SizedBox(height: 30),
            Row(children: [
              Text(
                'v2_confirm_that_its_you'.tr,
                style: MyFonts.medium(16),
                textAlign: TextAlign.left,
              )
            ]),
            SizedBox(
              height: 5,
            ),
            Row(children: [
              Text(
                'v2_please_enter_your_password_to_validate_account'.tr,
                style: MyFonts.regular(13, color: MyColors.grey),
                textAlign: TextAlign.left,
              )
            ]),
            SizedBox(height: 32),
            Row(children: [
              Text(
                'v2_reenter_your_password'.tr,
                style: MyFonts.medium(16),
                textAlign: TextAlign.left,
              )
            ]),
            SizedBox(
              height: 1,
            ),
            Row(children: [
              Expanded(
                  child: TextField(
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                          ),
                          hintText: '**************')))
            ]),
            SizedBox(
              height: 9,
            ),
            Row(children: [
              Text(
                'v2_forget_your_password'.tr,
                style: MyFonts.regular(13, color: MyColors.v2Green),
                textAlign: TextAlign.left,
              )
            ]),
            SizedBox(height: 32),
            Row(children: [
              Expanded(
                  child: abV2PrimaryButton('v2_button_text_cancel'.tr,
                      onTap: () => {}, fullWidth: true)),
              SizedBox(width: 10),
              Expanded(
                  child: abV2PrimaryButton('v2_button_text_authorize'.tr,
                      onTap: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    color: Color(0xffFFFFFF),
                                    width: 393.0,
                                    height: 393.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Image.asset(
                                                  'lib/images/v2/Group 3195.png',
                                                  height: 17,
                                                  width: 17,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 129,
                                        ),
                                        Container(
                                          width: 322,
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 30),
                                          child: Text(
                                            'Thank you for submitting your document image. We have successfully received it and it is currently being reviewed.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Roboto',
                                                color: Color(0xff00458D)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          },
                      fullWidth: true,
                      success: true)),
            ])
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

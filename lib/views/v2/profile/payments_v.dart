import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/v2/profile/payments_payedocuments_v.dart';
import 'package:extra_staff/views/v2/profile/payments_payehistory_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class V2ProfilePaymentsView extends StatefulWidget {
  const V2ProfilePaymentsView({Key? key}) : super(key: key);

  @override
  _V2ProfilePaymentsViewState createState() => _V2ProfilePaymentsViewState();
}

class _V2ProfilePaymentsViewState extends State<V2ProfilePaymentsView> {
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
                width: double.infinity,
                height: 437,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.zero),
                    boxShadow: [
                      BoxShadow(
                          //offset: Offset(0, 4),
                          color: MyColors.lightGrey, //edited
                          spreadRadius: 2,
                          blurRadius: 5 //edited
                          )
                    ]),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(children: [
                        Row(children: [
                          Text(
                            'PAYSLIP',
                            style:
                                MyFonts.bold(26, color: _myThemeColors.primary),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Row(children: [
                            SvgPicture.asset("lib/images/v2/payslip_icon.svg",
                                width: 15, height: 15),
                            SizedBox(width: 4),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Marble',
                                    style: MyFonts.bold(9,
                                        color: _myThemeColors.primary),
                                  ),
                                  Text(
                                    'BEAUTY & SPA',
                                    style: MyFonts.regular(7,
                                        color: _myThemeColors.primary),
                                  )
                                ])
                          ])
                        ]),
                        SizedBox(height: 40),
                        Row(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bill to',
                                  style: MyFonts.bold(9,
                                      color: _myThemeColors.primary),
                                ),
                                SizedBox(height: 2),
                                Container(
                                    constraints: BoxConstraints(
                                        minWidth: 30, maxWidth: 70),
                                    child: Text(
                                      'Business Company 123 Grand Avenue, 29102 Country +00 000 000 000 CIF: 0000000ABC',
                                      style: MyFonts.regular(7,
                                          color: _myThemeColors.primary),
                                    ))
                              ]),
                          Spacer(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Invoice',
                                  style: MyFonts.bold(9,
                                      color: _myThemeColors.primary),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '#12345',
                                  style: MyFonts.regular(7,
                                      color: _myThemeColors.primary),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Date',
                                  style: MyFonts.bold(9,
                                      color: _myThemeColors.primary),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '00/00/00',
                                  style: MyFonts.regular(7,
                                      color: _myThemeColors.primary),
                                )
                              ])
                        ]),
                        SizedBox(height: 18),
                        Divider(
                          height: 12,
                          thickness: 1,
                          color: _myThemeColors.primary,
                        ),
                        SizedBox(height: 18),
                        SizedBox(height: 4),
                        SizedBox(height: 165),
                      ])),
                  Container(
                    width: double.infinity,
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    color: _myThemeColors.primary,
                    child: Row(children: [
                      Text(
                        'info@marblespa.com',
                        style: MyFonts.regular(5, color: MyColors.white),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Text(
                        'www.marblespa.com',
                        style: MyFonts.regular(5, color: MyColors.white),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                  )
                ])),
            SizedBox(height: 25),
            Row(children: [
              Expanded(
                  child: abV2PrimaryButton('v2_download_as_a_pdf'.tr,
                      onTap: () => {}, fullWidth: true)),
              SizedBox(width: 10),
              Expanded(
                  child: abV2PrimaryButton('v2_send_to_email'.tr,
                      onTap: () => {}, fullWidth: true)),
            ]),
            SizedBox(height: 25),
            abV2PrimaryButton('v2_button_text_paye_history'.tr,
                onTap: () => {Get.to(() => V2ProfilePaymentsPayeHistoryView())},
                fullWidth: true),
            SizedBox(height: 21),
            abV2PrimaryButton('v2_button_text_paye_documents'.tr,
                onTap: () =>
                    {Get.to(() => V2ProfilePaymentsPayeDocumentsView())},
                fullWidth: true),
            SizedBox(height: 25),
          ],
        ));
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, 'v2_profile_payments_view_appbar_title'.tr,
        showBack: true);
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

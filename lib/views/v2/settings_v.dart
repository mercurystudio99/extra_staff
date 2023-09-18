import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/page_controller_v.dart';
import 'package:extra_staff/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class V2SettingsView extends StatefulWidget {
  const V2SettingsView({Key? key}) : super(key: key);

  @override
  _V2SettingsViewState createState() => _V2SettingsViewState();
}

class _V2SettingsViewState extends State<V2SettingsView> {
  bool _isLoading = false;
  int _selectedIndex = 4;
  bool _isLocationEnabled = true;
  bool _isFacialRecognitionEnabled = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    abV2GotoBottomNavigation(index, 4);
  }

  Widget getContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: Color(0xFF00458D),
                ),
              ),
              SizedBox(height: 17.0),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: 'Be Vietnam Pro',
                          fontSize: 16,
                          color: Color(0xFF748A9D),
                        ),
                      ),
                      Text(
                        'abc@gmail.com',
                        style: TextStyle(
                          fontFamily: 'Be Vietnam Pro',
                          fontSize: 16,
                          color: Color(0xFFA6BCD0),
                        ),
                      ),
                      SizedBox(height: 21.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontFamily: 'Be Vietnam Pro',
                                  fontSize: 16,
                                  color: Color(0xFF748A9D),
                                ),
                              ),
                              Text(
                                '+123456789',
                                style: TextStyle(
                                  fontFamily: 'Be Vietnam Pro',
                                  fontSize: 16,
                                  color: Color(0xFFA6BCD0),
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            'lib/images/v2/Group 3181.png',
                            height: 28,
                            width: 28,
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 39.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Device Settings',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    color: Color(0xFF00458D),
                  ),
                ),
                SizedBox(height: 17.0),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
                                      style: TextStyle(
                                        fontFamily: 'Be Vietnam Pro',
                                        fontSize: 16,
                                        color: Color(0xFF748A9D),
                                      ),
                                    ),
                                    Text(
                                      'London',
                                      style: TextStyle(
                                        fontFamily: 'Be Vietnam Pro',
                                        fontSize: 16,
                                        color: Color(0xFFA6BCD0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: Switch(
                                  value: _isLocationEnabled,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isLocationEnabled = value;
                                    });
                                    // Add your logic for handling the switch button change here
                                  },
                                  activeTrackColor: Color(0xFF00458D),
                                  activeColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontFamily: 'Be Vietnam Pro',
                                        fontSize: 16,
                                        color: Color(0xFF748A9D),
                                      ),
                                    ),
                                    Text(
                                      '**************',
                                      style: TextStyle(
                                        fontFamily: 'Be Vietnam Pro',
                                        fontSize: 16,
                                        color: Color(0xFFA6BCD0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'lib/images/v2/Group 3181.png',
                                height: 28,
                                width: 28,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Facial Recognition',
                                  style: TextStyle(
                                    fontFamily: 'Be Vietnam Pro',
                                    fontSize: 16,
                                    color: Color(0xFF748A9D),
                                  ),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: Switch(
                                  value: _isFacialRecognitionEnabled,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isFacialRecognitionEnabled = value;
                                    });
                                    // Add your logic for handling the switch button change here
                                  },
                                  activeTrackColor: Color(0xFF00458D),
                                  activeColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ])),
              ]),
              SizedBox(height: 56),
              Container(
                width: 156,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF888A8C),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    // Add your sign-out logic here
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    if (isWebApp)
                      Get.offAll(() => PageControllerView());
                    else
                      Get.offAll(() => SplashPage());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF888A8C),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 14,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 42.0),
              TextButton(
                onPressed: () {
                  // Add your logic for deleting the account here
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 16,
                    color: Color(0xFFA6BCD0),
                  ),
                ),
                //style: TextButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, 'v2_settings_view_appbar_title'.tr);
  }

  @override
  Widget build(BuildContext context) {
    return abV2MainWidgetWithLoadingOverlayScaffoldScrollView(
      context,
      _isLoading,
      appBar: getAppBar(),
      content: getContent(),
      bottomNavigationBar:
          abV2BottomNavigationBarA(_selectedIndex, _onItemTapped),
    );
  }
}

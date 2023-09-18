import 'dart:io';

import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/v2/profile/validate_account_license_v.dart';
import 'package:extra_staff/views/v2/profile/validate_account_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/theme.dart';

class V2ProfileMyDetailsSubDetailsView extends StatefulWidget {
  const V2ProfileMyDetailsSubDetailsView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsSubDetailsViewState createState() =>
      _V2ProfileMyDetailsSubDetailsViewState();
}

class _V2ProfileMyDetailsSubDetailsViewState
    extends State<V2ProfileMyDetailsSubDetailsView> {
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

  bool curentAdressLine = false;
  bool postcode = false;
  bool ofkin = false;
  bool number = false;

  Widget getContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Current Address Line',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                  ),
                  enabled: curentAdressLine,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    // Enable editing mode when the first image is tapped
                    setState(() {
                      curentAdressLine = true;
                    });
                    Get.to(() => V2ProfileValidateAccountViewLicense());
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3181.png',
                    height: 28,
                    width: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    // Open the image picker
                    final picker = ImagePicker();
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);

                    // Check if an image was picked
                    if (pickedImage != null) {
                      // Handle the picked image (you can save it, display it, or perform other actions)
                      File imageFile = File(pickedImage.path);
                      // You can now use the 'imageFile' for further processing
                      showDialog(
                        context:
                            context, // You need to have access to the context
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Row(children: [
                            Expanded(
                                child: abV2PrimaryButton('Cancel',
                                    onTap: () => {}, fullWidth: true)),
                            SizedBox(width: 10),
                            Expanded(
                                child: abV2PrimaryButton('Save',
                                    onTap: () => {
                                          Get.back(),
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Image.asset(
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 30,
                                                                right: 30),
                                                        child: Text(
                                                          'Changes Saved',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: Color(
                                                                  0xff00458D)),
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
                          ]));
                        },
                      );
                    }
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3255.png',
                    height: 44,
                    width: 57,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 67),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Post Code',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                  ),
                  enabled: postcode,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    // Enable editing mode when the first image is tapped
                    setState(() {
                      postcode = true;
                    });
                    Get.to(() => V2ProfileValidateAccountViewLicense());
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3181.png',
                    height: 28,
                    width: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    // Open the image picker
                    final picker = ImagePicker();
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);

                    // Check if an image was picked
                    if (pickedImage != null) {
                      // Handle the picked image (you can save it, display it, or perform other actions)
                      File imageFile = File(pickedImage.path);
                      // You can now use the 'imageFile' for further processing
                      showDialog(
                        context:
                            context, // You need to have access to the context
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Row(children: [
                            Expanded(
                                child: abV2PrimaryButton('Cancel',
                                    onTap: () => {}, fullWidth: true)),
                            SizedBox(width: 10),
                            Expanded(
                                child: abV2PrimaryButton('Save',
                                    onTap: () => {
                                          Get.back(),
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Image.asset(
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 30,
                                                                right: 30),
                                                        child: Text(
                                                          'Changes Saved',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: Color(
                                                                  0xff00458D)),
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
                          ]));
                        },
                      );
                    }
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3255.png',
                    height: 44,
                    width: 57,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 67),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Next of kin',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                  ),
                  enabled: ofkin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    // Enable editing mode when the first image is tapped
                    setState(() {
                      ofkin = true;
                    });
                    Get.to(() => V2ProfileValidateAccountViewLicense());
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3181.png',
                    height: 28,
                    width: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    // Open the image picker
                    final picker = ImagePicker();
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);

                    // Check if an image was picked
                    if (pickedImage != null) {
                      // Handle the picked image (you can save it, display it, or perform other actions)
                      File imageFile = File(pickedImage.path);
                      // You can now use the 'imageFile' for further processing
                      showDialog(
                        context:
                            context, // You need to have access to the context
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Row(children: [
                            Expanded(
                                child: abV2PrimaryButton('Cancel',
                                    onTap: () => {}, fullWidth: true)),
                            SizedBox(width: 10),
                            Expanded(
                                child: abV2PrimaryButton('Save',
                                    onTap: () => {
                                          Get.back(),
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Image.asset(
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 30,
                                                                right: 30),
                                                        child: Text(
                                                          'Changes Saved',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: Color(
                                                                  0xff00458D)),
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
                          ]));
                        },
                      );
                    }
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3255.png',
                    height: 44,
                    width: 57,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 67),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Phone number',
                style: TextStyle(fontSize: 16, color: MyColors.grey),
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCBD6E2)),
                    ),
                  ),
                  enabled: number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    // Enable editing mode when the first image is tapped
                    setState(() {
                      number = true;
                    });
                    Get.to(() => V2ProfileValidateAccountViewLicense());
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3181.png',
                    height: 28,
                    width: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    // Open the image picker
                    final picker = ImagePicker();
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);

                    // Check if an image was picked
                    if (pickedImage != null) {
                      // Handle the picked image (you can save it, display it, or perform other actions)
                      File imageFile = File(pickedImage.path);

                      // Show an alert dialog
                      showDialog(
                        context:
                            context, // You need to have access to the context
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Row(children: [
                            Expanded(
                                child: abV2PrimaryButton('Cancel',
                                    onTap: () => {}, fullWidth: true)),
                            SizedBox(width: 10),
                            Expanded(
                                child: abV2PrimaryButton('Save',
                                    onTap: () => {
                                          Get.back(),
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Image.asset(
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 30,
                                                                right: 30),
                                                        child: Text(
                                                          'Changes Saved',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: Color(
                                                                  0xff00458D)),
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
                          ]));
                        },
                      );
                    }
                  },
                  child: Image.asset(
                    'lib/images/v2/Group 3255.png',
                    height: 44,
                    width: 57,
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 67),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Text(
          //       'Availability',
          //       style: TextStyle(fontSize: 16, color: MyColors.grey),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 3),
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextFormField(
          //         style: TextStyle(fontSize: 16, color: MyColors.black),
          //         decoration: InputDecoration(
          //           contentPadding:
          //               EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          //           border: OutlineInputBorder(
          //             borderSide: BorderSide(color: Color(0xFFCBD6E2)),
          //           ),
          //         ),
          //         enabled: false,
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(5.0),
          //       child: Image.asset(
          //         'lib/images/v2/Group 3181.png',
          //         height: 28,
          //         width: 28,
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Image.asset(
          //         'lib/images/v2/Group 3255.png',
          //         height: 44,
          //         width: 57,
          //       ),
          //     ),
          //   ],
          // ),
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

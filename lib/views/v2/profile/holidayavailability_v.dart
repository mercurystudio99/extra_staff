import 'package:accordion/accordion.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../controllers/v2/profile/updateTempAvailInfo.dart';
import '../../../utils/theme.dart';

class V2ProfileHolidayAvailabilityView extends StatefulWidget {
  const V2ProfileHolidayAvailabilityView({Key? key}) : super(key: key);

  @override
  _V2ProfileHolidayAvailabilityViewState createState() =>
      _V2ProfileHolidayAvailabilityViewState();
}

class _V2ProfileHolidayAvailabilityViewState
    extends State<V2ProfileHolidayAvailabilityView> {
  MyThemeColors get _myThemeColors =>
      Theme.of(context).extension<MyThemeColors>()!;
  bool _isLoading = false;
  int _selectedIndex = 2;

  Map<String, bool> selectedDays = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => _isLoading = true);

    await _fetchAvailabilityInfo(); // Aapka API response

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchAvailabilityInfo() async {
    final response = await Services.shared.getTempAvailabilityInfo();

    setState(() {
      selectedDays = {
        'Monday': (response.result['monday'] == 'true' ? true : false),
        'Tuesday': (response.result['tuesday'] == 'true' ? true : false),
        'Wednesday': (response.result['wednesday'] == 'true' ? true : false),
        'Thursday': (response.result['thursday'] == 'true' ? true : false),
        'Friday': (response.result['friday'] == 'true' ? true : false),
        'Saturday': (response.result['saturday'] == 'true' ? true : false),
        'Sunday': (response.result['sunday'] == 'true' ? true : false),
        'Night Work': (response.result['night_work'] == 'true' ? true : false),
      };
    });
  }

  final _controller = V2ProfileUpdateAvailabilityController();

  // final _controller = V2ProfileUpdateAvailabilityController();
  // getData() async {
  //   setState(() => _isLoading = true);

  //   await _controller.updateTempAvailInfo(selectedDays); // Aapka API response

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    abV2GotoBottomNavigation(index, 2);
  }

  Widget getContent() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Profile/Holiday Availability',
          style: MyFonts.regular(20, color: _myThemeColors.primary),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: getContent23(),
        ),
      ],
    );
  }

  String formattedStart =
      ""; // Declare formattedStart outside the onRangeSelected callback
  String formattedEnd = "";
  List<bool> _isVisibleList = [];
  List<String> _titleList1 = [];
  List<String> _titleList2 = [];
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool isChecked = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  bool isOpen = false;
  // Widget getContent3() {
  //   return Accordion(
  //     paddingListTop: 0,
  //     maxOpenSections: 1,
  //     rightIcon: Padding(
  //       padding: const EdgeInsets.only(right: 12.0, left: 12),
  //       child: Image.asset(
  //         'lib/images/Polygon 1@2x.png',
  //         height: 8,
  //         width: 10,
  //       ),
  //     ),
  //     headerBorderRadius: 6,
  //     headerBackgroundColor: MyColors.v2Primary,
  //     headerPadding: EdgeInsets.symmetric(
  //       vertical: 13,
  //     ),
  //     children: [
  //       AccordionSection(
  //         isOpen: false, // Set the initial state here
  //         header: Text(
  //           "Request time off",
  //           style: TextStyle(
  //             fontSize: 11,
  //             fontWeight: FontWeight.bold,
  //             fontFamily: 'Roboto',
  //             color: Colors.white, // Set the text color to white
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //         content: SizedBox(
  //           height: 450,
  //           child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.3),
  //                     spreadRadius: 3,
  //                     blurRadius: 5,
  //                     offset: Offset(0, 3),
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 children: [
  //                   StatefulBuilder(
  //                       builder: (BuildContext context, StateSetter setState) {
  //                     return TableCalendar(
  //                       firstDay: DateTime(DateTime.now().year - 1),
  //                       lastDay: DateTime(DateTime.now().year + 1),
  //                       focusedDay: _focusedDay,
  //                       availableCalendarFormats: const {
  //                         CalendarFormat.month: 'Month',
  //                       },
  //                       rangeSelectionMode: _rangeSelectionMode,
  //                       rangeStartDay: _rangeStart,
  //                       rangeEndDay: _rangeEnd,
  //                       headerStyle: HeaderStyle(titleCentered: true),
  //                       calendarFormat: _calendarFormat,
  //                       selectedDayPredicate: (day) {
  //                         return isSameDay(_selectedDay, day);
  //                       },
  //                       onDaySelected: (selectedDay, focusedDay) {
  //                         if (!isSameDay(_selectedDay, selectedDay)) {
  //                           setState(() {
  //                             _selectedDay = selectedDay;
  //                             _focusedDay = focusedDay;
  //                             _rangeStart = null; // Important to clean those
  //                             _rangeEnd = null;
  //                             _rangeSelectionMode =
  //                                 RangeSelectionMode.toggledOff;
  //                           });
  //                         }
  //                       },
  //                       onRangeSelected: (start, end, focusedDay) async {
  //                         if (start != null && end != null) {
  //                           final selectedRange = end.difference(start).inDays;
  //                           if (selectedRange <= 30) {
  //                             formattedStart =
  //                                 "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
  //                             formattedEnd =
  //                                 "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
  //                           } else {
  //                             Get.snackbar(
  //                               'Minimum Selected days',
  //                               'Cannot select a range of more than 30 days',
  //                               backgroundColor: Colors.deepOrangeAccent,
  //                               colorText: Colors.white,
  //                               duration: Duration(seconds: 2),
  //                             );
  //                             return; // Return without updating the date range
  //                           }
  //                         }

  //                         setState(() {
  //                           _selectedDay = null;
  //                           _focusedDay = focusedDay;
  //                           _rangeStart = start;
  //                           _rangeEnd = end;
  //                           _rangeSelectionMode = RangeSelectionMode.toggledOn;

  //                           _isVisibleList = [];
  //                           _titleList1 = [];
  //                           _titleList2 = [];

  //                           if (start != null && end != null) {
  //                             // print("-----shift!!----------");
  //                           }
  //                         });
  //                       },
  //                       onFormatChanged: (format) {
  //                         if (_calendarFormat != format) {
  //                           setState(() {
  //                             _calendarFormat = format;
  //                           });
  //                         }
  //                       },
  //                       onPageChanged: (focusedDay) {
  //                         // No need to call `setState()` here
  //                         _focusedDay = focusedDay;
  //                       },
  //                     );
  //                   }),
  //                   Padding(
  //                     padding: const EdgeInsets.only(right: 8.0),
  //                     child: Align(
  //                       alignment: Alignment.bottomRight,
  //                       child: ElevatedButton(
  //                         onPressed: () async {
  //                           var holidayInfo;
  //                           if (formattedStart.isNotEmpty &&
  //                               formattedEnd.isNotEmpty) {
  //                             holidayInfo = await Services.shared
  //                                 .getTempHolidayInfo(
  //                                     formattedStart, formattedEnd);
  //                           }
  //                           print('date ${formattedStart}');
  //                           print(holidayInfo.result.runtimeType);
  //                           print(holidayInfo.result);
  //                           print(holidayInfo.errorCode);
  //                           int errormessage = holidayInfo.errorCode;
  //                           if (errormessage == 444 || errormessage == 120) {
  //                             Get.snackbar(
  //                               'Denied',
  //                               'Your request has been denied.',
  //                               backgroundColor: Colors.redAccent,
  //                               colorText: Colors.white,
  //                               duration: Duration(seconds: 4),
  //                             );
  //                           } else {
  //                             Get.snackbar(
  //                               '',
  //                               'Your request send to efos we will notify you.',
  //                               backgroundColor: Colors.green,
  //                               colorText: Colors.white,
  //                               duration: Duration(seconds: 2),
  //                             );
  //                           }
  //                         },
  //                         style: ButtonStyle(
  //                           backgroundColor: MaterialStateProperty.all<Color>(
  //                               Colors.green), // Set the background color
  //                           shape: MaterialStateProperty.all<
  //                               RoundedRectangleBorder>(RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(5.0),
  //                           )), // Remove border radius
  //                           minimumSize: MaterialStateProperty.all<Size>(
  //                             Size(150, 48),
  //                           ), // Set the button size
  //                         ),
  //                         child: Text(
  //                           'Request',
  //                           style: TextStyle(fontSize: 16, color: Colors.white),
  //                         ), // Set the font size
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //         ),

  //         contentBorderColor: MyColors.lightGrey,
  //       ),
  //     ],
  //   );
  // }

  // Widget getContent2And3() {
  //   final List<String> yearList = ["Update Availability"];

  //   return Accordion(
  //       paddingListTop: 0,
  //       paddingListBottom: 0,
  //       maxOpenSections: 1,
  //       rightIcon: Padding(
  //         padding: const EdgeInsets.only(right: 12.0, left: 12),
  //         child: Image.asset(
  //           'lib/images/Polygon 1@2x.png',
  //           height: 8,
  //           width: 10,
  //         ),
  //       ),
  //       headerBorderRadius: 6,
  //       headerBackgroundColor: MyColors.v2Primary,
  //       headerPadding: EdgeInsets.symmetric(
  //         vertical: 13,
  //       ),
  //       paddingBetweenClosedSections: double.nan,
  //       children: [
  //         AccordionSection(
  //           isOpen: selectedDays.isNotEmpty ? true : false,
  //           header: Text(
  //             "Update Availability",
  //             style: TextStyle(
  //               fontSize: 11,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: 'Roboto',
  //               color: Colors.white,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 height: 250,
  //                 child: ListView(
  //                   shrinkWrap: true,
  //                   children: selectedDays.keys.map((day) {
  //                     return StatefulBuilder(
  //                       builder: (BuildContext context, StateSetter setState) {
  //                         return Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             SizedBox(
  //                               width: 30,
  //                               height: 30,
  //                               child: Checkbox(
  //                                 value: selectedDays[day]!,
  //                                 activeColor: MyColors.darkBlue,
  //                                 onChanged: (bool? newValue) {
  //                                   setState(() {
  //                                     selectedDays[day] = newValue!;
  //                                   });
  //                                 },
  //                                 shape: CircleBorder(),
  //                               ),
  //                             ),
  //                             Text(
  //                               day,
  //                               style: TextStyle(
  //                                   fontFamily: 'Roboto', fontSize: 20),
  //                             ),
  //                           ],
  //                         );
  //                       },
  //                     );
  //                   }).toList(),
  //                 ),
  //               ),
  //               SizedBox(height: 16),
  //               Align(
  //                 alignment: Alignment.bottomRight,
  //                 child: TextButton(
  //                   onPressed: () async {
  //                     print('sdcsdcsdc ${selectedDays}');
  //                     bool anyDaySelected =
  //                         selectedDays.values.any((value) => value);

  //                     if (!anyDaySelected) {
  //                       Get.snackbar(
  //                         'Error',
  //                         'Please select at least one day.',
  //                         backgroundColor: Colors.red,
  //                         colorText: Colors.white,
  //                         duration: Duration(seconds: 2),
  //                       );
  //                       return; // Don't proceed with the API call
  //                     }
  //                     String errorMessage =
  //                         await _controller.updateTempAvailInfo(selectedDays);
  //                     if (errorMessage.isEmpty) {
  //                       print('API call success');
  //                       Get.snackbar(
  //                         'Success',
  //                         'Your data successfully updated',
  //                         backgroundColor: Colors.green,
  //                         colorText: Colors.white,
  //                         duration: Duration(seconds: 2),
  //                       );
  //                     } else {
  //                       // API call failed, handle error scenario
  //                     }
  //                   },
  //                   style: ButtonStyle(
  //                     backgroundColor: MaterialStateProperty.all<Color>(
  //                       Colors.green,
  //                     ),
  //                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                       RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                     ),
  //                     minimumSize: MaterialStateProperty.all<Size>(
  //                       Size(150, 48),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     'Update',
  //                     style: TextStyle(fontSize: 16, color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           contentBorderColor: MyColors.lightGrey,
  //         )
  //       ]);
  // }

  Widget getRequestTimeOffSection() {
    return Column(
      children: [
        SizedBox(
          height: 450,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return TableCalendar(
                      firstDay: DateTime(DateTime.now().year - 1),
                      lastDay: DateTime(DateTime.now().year + 1),
                      focusedDay: _focusedDay,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      rangeSelectionMode: _rangeSelectionMode,
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      headerStyle: HeaderStyle(titleCentered: true),
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                            _rangeSelectionMode = RangeSelectionMode.toggledOff;
                          });
                        }
                      },
                      onRangeSelected: (start, end, focusedDay) async {
                        if (start != null && end != null) {
                          final selectedRange = end.difference(start).inDays;
                          if (selectedRange <= 30) {
                            formattedStart =
                                "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
                            formattedEnd =
                                "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
                          } else {
                            Get.snackbar(
                              'Minimum Selected days',
                              'Cannot select a range of more than 30 days',
                              backgroundColor: Colors.deepOrangeAccent,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                            return; // Return without updating the date range
                          }
                        }

                        setState(() {
                          _selectedDay = null;
                          _focusedDay = focusedDay;
                          _rangeStart = start;
                          _rangeEnd = end;
                          _rangeSelectionMode = RangeSelectionMode.toggledOn;

                          _isVisibleList = [];
                          _titleList1 = [];
                          _titleList2 = [];

                          if (start != null && end != null) {
                            // print("-----shift!!----------");
                          }
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        // No need to call `setState()` here
                        _focusedDay = focusedDay;
                      },
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          var holidayInfo;
                          if (formattedStart.isNotEmpty &&
                              formattedEnd.isNotEmpty) {
                            holidayInfo = await Services.shared
                                .getTempHolidayInfo(
                                    formattedStart, formattedEnd);
                          }
                          print('date ${formattedStart}');
                          print(holidayInfo.result.runtimeType);
                          print(holidayInfo.result);
                          print(holidayInfo.errorCode);
                          int errormessage = holidayInfo.errorCode;
                          if (errormessage == 444 || errormessage == 120) {
                            Get.snackbar(
                              'Denied',
                              'Your request has been denied.',
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              duration: Duration(seconds: 4),
                            );
                          } else {
                            Get.snackbar(
                              '',
                              'Your request send to efos we will notify you.',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Set the background color
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )), // Remove border radius
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(150, 48),
                          ), // Set the button size
                        ),
                        child: Text(
                          'Request',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ), // Set the font size
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget getContent23() {
    final List<String> yearList = ["Update Availability", "Request time off"];

    return Accordion(
      paddingListTop: 0,
      paddingListBottom: 0,
      maxOpenSections: 1,
      rightIcon: Padding(
        padding: const EdgeInsets.only(right: 12.0, left: 12),
        child: Image.asset(
          'lib/images/Polygon 1@2x.png',
          height: 8,
          width: 10,
        ),
      ),
      headerBorderRadius: 6,
      headerBackgroundColor: MyColors.v2Primary,
      headerPadding: EdgeInsets.symmetric(
        vertical: 13,
      ),
      paddingBetweenClosedSections: double.nan,
      children: [
        AccordionSection(
          isOpen: selectedDays.isNotEmpty ? true : false,
          header: Text(
            "Update Availability",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 250,
                child: ListView(
                  shrinkWrap: true,
                  children: selectedDays.keys.map((day) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Checkbox(
                                value: selectedDays[day]!,
                                activeColor: MyColors.darkBlue,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    selectedDays[day] = newValue!;
                                  });
                                },
                                shape: CircleBorder(),
                              ),
                            ),
                            Text(
                              day,
                              style:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 20),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () async {
                    print('sdcsdcsdc ${selectedDays}');
                    bool anyDaySelected =
                        selectedDays.values.any((value) => value);

                    if (!anyDaySelected) {
                      Get.snackbar(
                        'Error',
                        'Please select at least one day.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: Duration(seconds: 2),
                      );
                      return; // Don't proceed with the API call
                    }
                    String errorMessage =
                        await _controller.updateTempAvailInfo(selectedDays);
                    if (errorMessage.isEmpty) {
                      print('API call success');
                      Get.snackbar(
                        'Success',
                        'Your data successfully updated',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: Duration(seconds: 2),
                      );
                    } else {
                      // API call failed, handle error scenario
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(150, 48),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          contentBorderColor: MyColors.lightGrey,
        ),
        AccordionSection(
          isOpen: false, // Set the initial state here
          header: Text(
            "Request time off",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Colors.white, // Set the text color to white
            ),
            textAlign: TextAlign.center,
          ),
          content: getRequestTimeOffSection(),
          contentBorderColor: MyColors.lightGrey,
        ),
      ],
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

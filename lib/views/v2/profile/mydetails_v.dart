import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/v2/profile/mydetails_bankdetails_v.dart';
import 'package:extra_staff/views/v2/profile/mydetails_license_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../utils/theme.dart';
import 'mydetails_mydetails_v.dart';

class V2ProfileMyDetailsView extends StatefulWidget {
  const V2ProfileMyDetailsView({Key? key}) : super(key: key);

  @override
  _V2ProfileMyDetailsViewState createState() => _V2ProfileMyDetailsViewState();
}

class _V2ProfileMyDetailsViewState extends State<V2ProfileMyDetailsView> {
  MyThemeColors get _myThemeColors =>
      Theme.of(context).extension<MyThemeColors>()!;

  bool _isLoading = false;
  int _selectedIndex = 2;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime selectedDay = DateTime.now();
  double opacityLevel = 1.0;

  List<bool> _isVisibleList = [];
  List<String> _titleList1 = [];
  List<String> _titleList2 = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    abV2GotoBottomNavigation(index, 2);
  }

  Future<void> _loadShiftData(
      String formattedStart, String formattedEnd) async {
    try {
      final shiftData = await Services.shared
          .getTempWorkHistoryInfo(formattedStart, formattedEnd);

      if (shiftData.result is Map) {
        shiftData.result.forEach((key, value) {
          if (key != 'id' && key != 'user_id' && key != 'temp_id') {
            _isVisibleList.add(true);
            _titleList1.add(value['company_name']);
            var jobDate = value['job_date'];
            DateTime JobDateValue = DateTime.parse(jobDate);
            String FormatedJobDate =
                DateFormat('EEEE, MMMM d, y').format(JobDateValue);
            _titleList2.add(FormatedJobDate);
          }
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading shift data: $e');
    }
  }

  Widget getContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 1),
          abV2PrimaryButton(
            'MY DETAILS',
            onTap: () => {Get.to(() => V2ProfileMyDetailsMyDetailsView())},
            fullWidth: true,
          ),
          SizedBox(height: 13),
          abV2PrimaryButton(
            'BANK DETAILS',
            onTap: () => {Get.to(() => V2ProfileMyDetailsBankDetailsView())},
            fullWidth: true,
          ),
          SizedBox(height: 13),
          abV2PrimaryButton(
            'LICENSES',
            onTap: () => {Get.to(() => V2ProfileLicenseView())},
            fullWidth: true,
          ),
          SizedBox(height: 38),
          Center(
            child: Text(
              'History',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF00458D),
              ),
            ),
          ),
          SizedBox(height: 14),
          SizedBox(
            height: 400,
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
              child: TableCalendar(
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
                    Duration difference = end.difference(start);
                    int numberOfDays = difference.inDays;

                    if (numberOfDays > 30) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Wrong'),
                            content: Text(
                                'Sorry, you cannot select a range longer than 30 days.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  // Close the dialog or reset the selected range
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    String formattedStart =
                        "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
                    String formattedEnd =
                        "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

                    setState(() {
                      _isVisibleList = [];
                      _titleList1 = [];
                      _titleList2 = [];

                      if (start != null && end != null) {
                        _loadShiftData(formattedStart, formattedEnd);
                      }
                    });
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
              ),
            ),
          ),
          for (int i = 0;
              i < _isVisibleList.length;
              i++) // Iterate over the list
            Column(
              children: [
                SizedBox(height: 38),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        //spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  // color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Company name:',
                                  style: TextStyle(
                                    color: Color(0xff888A8C),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _titleList1[i],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date:',
                                  style: TextStyle(
                                    color: Color(0xff888A8C),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _titleList2[i],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 30),
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
      context,
      _isLoading,
      appBar: getAppBar(),
      content: getContent(),
      bottomNavigationBar:
          abV2BottomNavigationBarA(_selectedIndex, _onItemTapped),
    );
  }
}

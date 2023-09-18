import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/utils/theme.dart';
import 'package:extra_staff/views/v2/home_v.dart';
import 'package:extra_staff/views/v2/profile_v.dart';
import 'package:extra_staff/views/v2/notifications_v.dart';
import 'package:extra_staff/views/v2/settings_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';

class V2WorkView extends StatefulWidget {
  const V2WorkView({Key? key}) : super(key: key);

  @override
  _V2WorkViewState createState() => _V2WorkViewState();
}

class _V2WorkViewState extends State<V2WorkView> {
  late Future<void> _loadShiftDataFuture;
  bool _isLoading = true;
  int _selectedIndex = 1;
  bool _isCalendarVisible = false;

  late CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime selectedDay = DateTime.now();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<bool> _isVisibleList = [];
  List<String> _titleList1 = [];
  List<String> _titleList2 = [];
  List<String> _titleList3 = [];
  List<String> _titleList4 = [];

  String tomorrowLabel = "Tomorrow ";
  late DateTime nowt;
  late DateTime tomorrowt;
  late String tomorrow;
  late String formattedTomorrow;

  @override
  void initState() {
    super.initState();
    nowt = DateTime.now();
    tomorrowt = nowt.add(Duration(days: 1));
    tomorrow = DateFormat('yyyy-MM-dd').format(tomorrowt);
    formattedTomorrow = DateFormat('EEEE, MMMM d, y').format(tomorrowt);

    _loadShiftDataFuture = _loadShiftData(tomorrow);
  }

  Future<void> _loadShiftData(String shiftDate) async {
    try {
      final shiftData = await Services.shared.getTempShiftInfo(shiftDate);

      if (shiftData.result is Map) {
        shiftData.result.forEach((key, value) {
          if (key != 'id' && key != 'user_id' && key != 'temp_id') {
            _isVisibleList.add(true);
            _titleList1.add(value['start_time']);
            _titleList2.add(value['end_time']);
            _titleList3.add(value['job_title']);
            _titleList4.add(value['status']);
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

  MyThemeColors get _myThemeColors =>
      Theme.of(context).extension<MyThemeColors>()!;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    abV2GotoBottomNavigation(index, 1);
  }

  Widget getThisWeeksSelectorItemWidget(
      String startTime, String endTime, String title, String type) {
    return Container(
        height: 100,
        width: 322,
        // width: double.infinity,
        padding: EdgeInsets.all(16),
        color: _myThemeColors.itemContainerBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(startTime,
                    style: MyFonts.regular(14, color: MyColors.grey)),
                SizedBox(width: 7),
                Container(
                  width: 15,
                  height: 24,
                  // Negative padding
                  transform: Matrix4.translationValues(0.0, 13.0, 0.0),
                  // Add top border
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: MyColors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Text(endTime, style: MyFonts.regular(14, color: MyColors.grey))
              ],
            ),
            SizedBox(width: 37),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: MyFonts.regular(14),
                ),
                SizedBox(height: 28),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(type,
                        style: MyFonts.regular(10, color: MyColors.grey)),
                  ],
                )
              ],
            ))
          ],
        ));
  }

  Widget getContent() {
    Widget mapToJob = Column(children: [
      Column(
        children: [
          SizedBox(height: 28),
          Container(
            height: 167,
            width: 322,
            color: MyColors.grey,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(51.509364, -0.128928),
                zoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),
          ),
          SizedBox(height: 35),
          Container(
              height: 88,
              width: 322,
              padding: EdgeInsets.all(20),
              color: _myThemeColors.itemContainerBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text("Get more infos for yout Active/Today's shift...",
                          style: MyFonts.regular(14)),
                    ],
                  )),
                  SizedBox(width: 60),
                  SvgPicture.asset("lib/images/v2/phone.svg",
                      width: 48, height: 48),
                ],
              ))
        ],
      )
    ]);

    Widget thisWeeksShiftSelector = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isCalendarVisible =
                    !_isCalendarVisible; // Toggle the visibility of the calendar widget
              });
            },
            child: Image.asset(
              'lib/images/v2/Icon metro-calendar.png',
              height: 22.72,
              width: 21.3,
            ),
          ),
          SizedBox(width: 34),
          Text(
            'v2_this_weeks_shift_selector'.tr,
            style: MyFonts.regular(20, color: _myThemeColors.primary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      SizedBox(height: 10),
      if (_isCalendarVisible)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TableCalendar(
            firstDay: DateTime(DateTime.now().year - 1),
            lastDay: DateTime(DateTime.now().year + 1),
            focusedDay: _focusedDay,
            availableCalendarFormats: const {
              CalendarFormat.week: 'week',
            },
            headerVisible: false,
            availableGestures: AvailableGestures.none,
            headerStyle: HeaderStyle(titleCentered: true),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              if (!isSameDay(_selectedDay, selectedDay)) {
                String formattedDate =
                    "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";

                setState(() {
                  formattedTomorrow =
                      DateFormat('EEEE, MMMM d, y').format(selectedDay);

                  if (isSameDay(selectedDay, tomorrowt))
                    tomorrowLabel = "Tomorrow ";
                  else
                    tomorrowLabel = "";

                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;

                  _isVisibleList = [];
                  _titleList1 = [];
                  _titleList2 = [];
                  _titleList3 = [];
                  _titleList4 = [];

                  _loadShiftData(formattedDate);
                });
              }
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
      SizedBox(height: 20),
      RichText(
        text: TextSpan(
          style: MyFonts.regular(16, color: MyColors.grey),
          children: <TextSpan>[
            TextSpan(
              text: tomorrowLabel,
              style: TextStyle(color: _myThemeColors.primary),
            ),
            TextSpan(text: formattedTomorrow),
          ],
        ),
      ),
      for (int i = 0; i < _isVisibleList.length; i++) // Iterate over the list
        Column(
          children: [
            SizedBox(height: 28),
            getThisWeeksSelectorItemWidget(
              _titleList1[i],
              _titleList2[i],
              _titleList3[i],
              _titleList4[i],
            ),
          ],
        ),
      SizedBox(height: 16),
    ]);

    return FutureBuilder<void>(
      future: _loadShiftDataFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while data is being fetched
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle the error case
          return Text('Error loading shift data');
        } else {
          // Display the content once the data is loaded
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mapToJob,
                SizedBox(height: 32),
                thisWeeksShiftSelector,
              ],
            ),
          );
        }
      },
    );
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, 'v2_work_view_appbar_title'.tr);
  }

  @override
  Widget build(BuildContext context) {
    print(_titleList1);
    return abV2MainWidgetWithLoadingOverlayScaffoldScrollView(
        context, _isLoading,
        appBar: getAppBar(),
        content: getContent(),
        bottomNavigationBar:
            abV2BottomNavigationBarA(_selectedIndex, _onItemTapped));
  }
}

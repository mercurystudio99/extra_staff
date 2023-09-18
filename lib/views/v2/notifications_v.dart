import 'package:extra_staff/utils/ab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class V2NotificationsView extends StatefulWidget {
  const V2NotificationsView({Key? key}) : super(key: key);

  @override
  _V2NotificationsViewState createState() => _V2NotificationsViewState();
}

class _V2NotificationsViewState extends State<V2NotificationsView> {
  bool _isLoading = false;
  int _selectedIndex = 3;
  List<bool> _isVisibleList = [
    true,
    true,
    true,
    true
  ]; // Example list of Boolean values
  List<String> _titleList = [
    'Your requested time off has been approved. Enjoy your well-deserved break.',
    'Your updated availability has been successfully recorded. You"re now set to work 4 days a week.',
    'Your requested P45 document has been successfully sent to your email. Please check your inbox for further instructions.',
    'Your password has been successfully updated.'
  ]; // Example list of titles
  List<String> _subtitleList = [
    '2 min ago',
    '24 hours ago',
    '24 hours ago',
    '24 hours ago'
  ]; // Example list of subtitles

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    abV2GotoBottomNavigation(index, 3);
  }

  Widget getContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    color: Color(0xFF00458D),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Mark all as read',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Color(0xFF00458D),
                    ),
                  ),
                ),
              ),
            ],
          ),
          for (int i = 0;
              i < _isVisibleList.length;
              i++) // Iterate over the list
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: _isVisibleList[i]
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 310,
                        height: 78,
                        child: Text(
                          _titleList[i], // Use the title from the list
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff00458D),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isVisibleList[i] =
                                false; // Set the visibility of the current list tile to false
                          });
                        },
                        child: Image.asset(
                          'lib/images/v2/Group 3195.png',
                          height: 17,
                          width: 17,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                      top: 12,
                    ),
                    child: Text(
                      _subtitleList[i],
                      style: TextStyle(fontSize: 13, color: Color(0xff888A8C)),
                    ), // Use the subtitle from the list
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
                ),
              ),
              secondChild: Opacity(
                opacity: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xff707070),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ), // Use an empty SizedBox for hidden titles
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, ''.tr);
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

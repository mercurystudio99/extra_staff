import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/v2/home_v.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RegistrationComplete extends StatefulWidget {
  const RegistrationComplete({Key? key}) : super(key: key);

  @override
  _RegistrationCompleteState createState() => _RegistrationCompleteState();
}

class _RegistrationCompleteState extends State<RegistrationComplete>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    saveProcess();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller!);

    _controller!.addListener(() {
      setState(() {});
    });

    _controller!.forward();

    _timer = Timer(Duration(seconds: 2), navigateToNextPage);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  saveProcess() async {
    await localStorage?.setBool('isAgreementsCompleted', true);
    final result = await Services.shared.getTempProgressInfo();
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    } else {
      await localStorage?.setString('completed', result.result['completed']);
      await Services.shared.setData();
    }
  }

  navigateToNextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => V2HomeView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 89,
            left: -51,
            width: 102,
            height: 89,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: MyColors.v2Primary),
              ),
            ),
          ),
          Positioned(
            top: 74,
            right: 69,
            width: 47,
            height: 37,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: MyColors.v2Primary),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 1 - _animation!.value,
                  child: Text(
                    'Welcome to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 46,
                      color: MyColors.v2Primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 1 - _animation!.value,
                  child: Text(
                    'Extrastaff',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 46,
                      color: MyColors.v2Primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 62,
            bottom: 204,
            width: 36,
            height: 38,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: MyColors.v2Primary),
              ),
            ),
          ),
          Positioned(
            left: -18,
            bottom: -19,
            width: 36,
            height: 38,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: MyColors.v2Primary),
              ),
            ),
          ),
          Positioned(
            right: -133,
            bottom: 31,
            width: 236,
            height: 203,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: MyColors.v2Primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/page_controller_v.dart';
import 'package:extra_staff/views/confirm_code_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController? _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    String splashName = getSplashVideoName();
    print(splashName);
    _controller = VideoPlayerController.asset(splashName);
    _controller!.initialize().then((_) {
      _controller!.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller!.play();
          _visible = true;
        });
      });
    });

    Future.delayed(Duration(milliseconds: 2990), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        if ((localStorage?.getString('passcode') ?? '').isNotEmpty) {
          return EnterConfrimCode(isFromStart: true);
        } else {
          return PageControllerView();
        }
      }), (e) => false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller!),
    );
  }

  String getSplashVideoName() {
    String filename = "lib/images/Splash.mp4";
    if (defaultTargetPlatform == TargetPlatform.android) {
      filename = "lib/images/Splash_Android.mp4";
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      filename = "lib/images/Splash.mp4";
      final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
      if (data.size.shortestSide >= 600) {
        //tablet
        filename = "lib/images/Splash_iPad.mp4";
      }
    }
    return filename;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("=============sdwwwwww=====================");
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
          ],
        ),
      ),
    );
  }
}

import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/analysing_docs.v.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';
import 'package:extra_staff/views/v2/help_v.dart';
import 'package:extra_staff/views/v2/work_v.dart';
import 'package:extra_staff/views/v2/profile/payments_payehistory_v.dart';
import 'package:extra_staff/views/v2/profile/validate_account_v.dart';
import 'package:extra_staff/views/v2/profile_v.dart';
import 'package:extra_staff/views/v2/profile/payments_v.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/theme.dart';
import 'package:extra_staff/utils/messages.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:extra_staff/views/splash_screen.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';
import 'package:extra_staff/views/page_controller_v.dart';
import 'package:extra_staff/views/confirm_code_v.dart';
import 'package:extra_staff/utils/none.dart'
    if (dart.library.html) 'package:extra_staff/utils/web_ab.dart';
import 'package:extra_staff/views/v2/home_v.dart';
import 'package:flutter/gestures.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

Future<void> main() async {
  if (isWebApp) {
    await localStorageInit();
    initBaseUrl();
  }
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://88860a0eff1c47f992da8f92edfc84f0@o1329473.ingest.sentry.io/6591681';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(ExtraStaff(savedThemeMode: savedThemeMode)),
  );
}

class ExtraStaff extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const ExtraStaff({this.savedThemeMode});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      if (objABBottom.hideBottom != isKeyboardVisible) {
        objABBottom.hideBottom = isKeyboardVisible;
        objABBottom.update();
      }
      return KeyboardDismissOnTap(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (e) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (!disableFallbackTimer) {
              if (timer != null) {
                fallBackTimer(false);
              }
            }
          },
          child: AdaptiveTheme(
            light: MyThemes.light,
            dark: MyThemes.dark,
            initial: savedThemeMode ?? AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => GetMaterialApp(
              title: 'Extrastaff Registration',
              scrollBehavior: MyCustomScrollBehavior(),
              theme: theme,
              darkTheme: darkTheme,
              //home: RegistrationComplete(),
              home: !isWebApp
                  ? SplashPage()
                  : ((localStorage?.getString('passcode') ?? '').isNotEmpty
                      ? EnterConfrimCode(isFromStart: true)
                      // ? AnalysingDocs(seconds: Duration(seconds: 100)) //TEST
                      : PageControllerView()),
              enableLog: false,
              debugShowCheckedModeBanner: false,
              translations: Messages(),
              locale: Locale('en', ''),
              fallbackLocale: Locale('en', ''),
              onInit: () async {
                await localStorageInit();
                await Resume.shared.getClass();
                Services.shared.setData();
                if (isiOS) {
                  Future.delayed(Duration(seconds: 3), () async {
                    await AppTrackingTransparency
                        .requestTrackingAuthorization();
                  });
                }
              },
              initialRoute: '/',
              // routes: {
              //   '/': (context) => V2HomeView(),
              //   '/V2HomeView': (context) => V2HomeView(),
              //   '/V2HelpView': (context) => V2HelpView(),
              //   '/V2ProfileView': (context) => V2ProfileView(),
              //   '/V2ProfileValidateAccountView': (context) =>
              //       V2ProfileValidateAccountView(),
              //   '/V2ProfilePaymentsView': (context) => V2ProfilePaymentsView(),
              //   '/V2ProfilePaymentsPayeHistoryView': (context) =>
              //       V2ProfilePaymentsPayeHistoryView(),
              //   '/V2WorkView': (context) => V2WorkView(),
              // },
            ),
          ),
        ),
      );
    });
  }
}

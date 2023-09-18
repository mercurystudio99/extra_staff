import 'dart:async';
import 'package:extra_staff/views/confirm_code_v.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:extra_staff/views/registration_progress_v.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/v2/home_v.dart';
import 'package:extra_staff/views/v2/work_v.dart';
import 'package:extra_staff/views/v2/profile_v.dart';
import 'package:extra_staff/views/v2/notifications_v.dart';
import 'package:extra_staff/views/v2/settings_v.dart';
import 'package:extra_staff/utils/theme.dart';

T ab<T>(dynamic x, {required T fallback}) => x is T ? x : fallback;

class ABBottom extends GetxController {
  bool hideBottom = false;
}

final objABBottom = ABBottom();

Timer? timer;

fallBackTimer(bool stop) {
  timer?.cancel();
  if (stop) {
    timer = null;
    return;
  }
  print('fallBackTimer');
  timer = Timer(Duration(minutes: 3), () {
    timer = null;
    Get.offAll(() => EnterConfrimCode(isFromStart: true));
  });
}

PreferredSize abQuestions(
    BuildContext context, bool showHome, int current, int total) {
  final width = MediaQuery.of(context).size.width;
  final indent = ((width - 56) / total) * current;
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
    child: SafeArea(
      child: Container(
        padding: gHPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  total == 0
                      ? Container()
                      : Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                (current <= 9 ? '0' : '') + '$current',
                                textAlign: TextAlign.center,
                                style: MyFonts.medium(28),
                              ),
                              Text(
                                '/ ${(total <= 9 ? '0' : '')}$total',
                                textAlign: TextAlign.center,
                                style: MyFonts.medium(18, color: MyColors.grey),
                              ),
                            ],
                          ),
                        ),
                  Container(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: MyColors.grey,
                      ),
                    ),
                  ),
                  showHome
                      ? Container(
                          height: 40,
                          alignment: AlignmentDirectional.centerEnd,
                          child: IconButton(
                            onPressed: () {
                              Get.to(() => RegistrationProgress());
                            },
                            icon: Icon(
                              Icons.home,
                              size: 30,
                              color: MyColors.lightBlue,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Spacer(),
            total == 0
                ? Container(height: 10)
                : SizedBox(
                    height: 10,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Divider(
                          height: 0,
                          thickness: 2,
                          color: MyColors.grey,
                        ),
                        AnimatedContainer(
                          color: MyColors.darkBlue,
                          height: 8,
                          width: indent,
                          duration: duration,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

PreferredSize abQuestionsNew(
    BuildContext context, bool showHome, int current, int total) {
  final width = MediaQuery.of(context).size.width;
  final indent = ((width - 56) / total) * current;
  if (isWebApp) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: SafeArea(
        child: Container(
          padding: gHPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(
                child: Row(
                  children: [
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          total == 0
                              ? Container()
                              : Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        (current <= 9 ? '0' : '') + '$current',
                                        textAlign: TextAlign.center,
                                        style: MyFonts.medium(28),
                                      ),
                                      Text(
                                        '/ ${(total <= 9 ? '0' : '')}$total',
                                        textAlign: TextAlign.center,
                                        style: MyFonts.medium(18,
                                            color: MyColors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                          Container(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: MyColors.grey,
                              ),
                            ),
                          ),
                          showHome
                              ? Container(
                                  height: 40,
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.offAll(() => RegistrationProgress());
                                    },
                                    icon: Icon(
                                      Icons.home,
                                      size: 30,
                                      color: MyColors.lightBlue,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  ],
                ),
              ),
              Spacer(),
              total == 0
                  ? Container(height: 10)
                  : SizedBox(
                      height: 10,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Divider(
                            height: 0,
                            thickness: 2,
                            color: MyColors.grey,
                          ),
                          AnimatedContainer(
                            color: MyColors.darkBlue,
                            height: 8,
                            width: indent,
                            duration: duration,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  } else {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: SafeArea(
        child: Container(
          padding: gHPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    total == 0
                        ? Container()
                        : Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  (current <= 9 ? '0' : '') + '$current',
                                  textAlign: TextAlign.center,
                                  style: MyFonts.medium(28),
                                ),
                                Text(
                                  '/ ${(total <= 9 ? '0' : '')}$total',
                                  textAlign: TextAlign.center,
                                  style:
                                      MyFonts.medium(18, color: MyColors.grey),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: MyColors.grey,
                        ),
                      ),
                    ),
                    showHome
                        ? Container(
                            height: 40,
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                              onPressed: () {
                                Get.offAll(() => RegistrationProgress());
                              },
                              icon: Icon(
                                Icons.home,
                                size: 30,
                                color: MyColors.lightBlue,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Spacer(),
              total == 0
                  ? Container(height: 10)
                  : SizedBox(
                      height: 10,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Divider(
                            height: 0,
                            thickness: 2,
                            color: MyColors.grey,
                          ),
                          AnimatedContainer(
                            color: MyColors.darkBlue,
                            height: 8,
                            width: indent,
                            duration: duration,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget abSimpleButton(String title,
    {required Function() onTap, Color? backgroundColor}) {
  final frontColor =
      backgroundColor != null ? MyColors.white : MyColors.darkBlue;
  final borderWidth = backgroundColor == null ? 2.0 : 0.0;
  return InkWell(
    onTap: () async => onTap(),
    child: AnimatedContainer(
      duration: duration,
      constraints: BoxConstraints(minHeight: buttonHeight),
      padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? MyColors.white,
        border: Border.all(
            color: backgroundColor ?? MyColors.darkBlue, width: borderWidth),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: MyFonts.regular(24, color: frontColor)),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, color: frontColor),
        ],
      ),
    ),
  );
}

Widget abDropDownButton(
    KeyValue selected, List<KeyValue> options, Function(KeyValue) onChange,
    {Color? bordercolor, bool? disable}) {
  return Container(
    height: buttonHeight,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: abOutline(borderColor: bordercolor),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        icon: RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.arrow_forward_ios,
              color: disable == null || disable == false
                  ? MyColors.darkBlue
                  : MyColors.grey),
        ),
        value: selected,
        onChanged: disable == null || disable == false
            ? (KeyValue? newValue) async => onChange(newValue!)
            : null,
        // onChanged: null,
        items: options
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.value,
                    style: MyFonts.regular(17, color: MyColors.black),
                  ),
                ))
            .toList(),
      ),
    ),
  );
}

Widget abDropDownButtonFormField(
    KeyValue selected, List<KeyValue> options, Function(KeyValue) onChange,
    {Color? bordercolor, bool? disable}) {
  return Container(
    height: buttonHeight,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: abOutline(borderColor: bordercolor),
    child: DropdownButtonHideUnderline(
      child: DropdownButtonFormField<KeyValue>(
        isExpanded: true,
        icon: RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.arrow_forward_ios,
              color: disable == null || disable == false
                  ? MyColors.darkBlue
                  : MyColors.grey),
        ),
        value: selected,
        validator: (value) => value?.id == '' ? 'Required' : null,
        onChanged: disable == null || disable == false
            ? (KeyValue? newValue) async => onChange(newValue!)
            : null,
        // onChanged: null,
        items: options
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.value,
                    style: MyFonts.regular(17, color: MyColors.black),
                  ),
                ))
            .toList(),
      ),
    ),
  );
}

Widget abStatusButtonWidget(Widget title, bool? status, Function() onTap,
    {bool hideStatus = false, bool expanded = false, double? borderWidth}) {
  final color = status != null
      ? status
          ? MyColors.green
          : MyColors.ornage
      : MyColors.lightGrey;
  final icon = status != null
      ? status
          ? Icons.check_circle
          : Icons.cancel
      : Icons.add_circle;
  return InkWell(
    onTap: onTap,
    child: Container(
      height: expanded ? null : buttonHeight,
      padding:
          expanded ? EdgeInsets.all(16) : EdgeInsets.symmetric(horizontal: 16),
      decoration: abOutline(borderColor: color, width: borderWidth),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: title,
          ),
          if (!hideStatus)
            Positioned(
              top: 43,
              right: -27,
              child: Icon(icon, color: color),
            ),
        ],
      ),
    ),
  );
}

Widget abStatusButton(String title, bool? status, Function() onTap,
    {bool hideStatus = false, bool expanded = false, double? borderWidth}) {
  final color = status != null
      ? status
          ? MyColors.green
          : MyColors.ornage
      : MyColors.lightGrey;
  final icon = status != null
      ? status
          ? Icons.check_circle
          : Icons.cancel
      : Icons.add_circle;
  return InkWell(
    onTap: onTap,
    child: Container(
      height: expanded ? null : buttonHeight,
      padding:
          expanded ? EdgeInsets.all(16) : EdgeInsets.symmetric(horizontal: 16),
      decoration: abOutline(borderColor: color, width: borderWidth),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(title,
                style: MyFonts.regular(17, color: MyColors.black),
                textAlign: expanded ? TextAlign.center : null),
          ),
          if (!hideStatus)
            Positioned(
              top: 43,
              right: -27,
              child: Icon(icon, color: color),
            ),
        ],
      ),
    ),
  );
}

Widget abDownButton(String title) {
  return Container(
    height: buttonHeight,
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: abOutline(),
    child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MyFonts.regular(17, color: MyColors.black)),
          RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.arrow_forward_ios, color: MyColors.darkBlue),
          ),
        ],
      ),
    ),
  );
}

BoxDecoration abOutline({Color? borderColor, Color? color, double? width}) {
  double borderWidth = borderColor == MyColors.transparent ? 0 : width ?? 1;
  return BoxDecoration(
    color: color ?? MyColors.white,
    border: Border.all(
        color: borderColor ?? MyColors.lightGrey, width: borderWidth),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(color: MyColors.lightGrey, spreadRadius: 0, blurRadius: 2),
    ],
  );
}

Widget abPasswordField(String title, Function(String) onChanged,
    {TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    int? clearAndEdit,
    Function(int)? onTap,
    String? Function(String?)? validator,
    Function(String)? onFieldSubmitted}) {
  return Container(
    decoration: abOutline(borderColor: MyColors.transparent),
    child: TextFormField(
      validator: validator,
      initialValue: title,
      style: MyFonts.regular(16),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      textCapitalization: TextCapitalization.sentences,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (e) => onChanged(e),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (e) =>
          onFieldSubmitted == null ? null : onFieldSubmitted(e),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.all(16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.skyBlue, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.lightGrey, width: 1),
        ),
        suffixIcon: clearAndEdit == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (clearAndEdit == 1)
                    IconButton(
                      onPressed: () => onTap == null ? null : onTap(1),
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.clear),
                    ),
                  if (clearAndEdit == 2)
                    IconButton(
                      onPressed: () => onTap == null ? null : onTap(2),
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.edit),
                    ),
                ],
              ),
      ),
    ),
  );
}

Widget abTextField(String title, Function(String) onChanged,
    {TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    int? clearAndEdit,
    String? hintText,
    Function(int)? onTap,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Function(String)? onFieldSubmitted,
    bool readOnly = false,
    TextEditingController? controller}) {
  if (controller == null) {
    return Container(
      decoration: abOutline(borderColor: MyColors.transparent),
      child: TextFormField(
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        validator: validator,
        initialValue: title,
        style: MyFonts.regular(16),
        textCapitalization: TextCapitalization.sentences,
        maxLength: maxLength ?? (maxLines == 1 ? 45 : 256),
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: (e) => onChanged(e),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (e) =>
            onFieldSubmitted == null ? null : onFieldSubmitted(e),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          contentPadding: EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.skyBlue, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.lightGrey, width: 1),
          ),
          suffixIcon: clearAndEdit == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (clearAndEdit == 1)
                      IconButton(
                        onPressed: () => onTap == null ? null : onTap(1),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.clear),
                      ),
                    if (clearAndEdit == 2)
                      IconButton(
                        onPressed: () => onTap == null ? null : onTap(2),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.edit),
                      ),
                  ],
                ),
        ),
      ),
    );
  } else {
    return Container(
      decoration: abOutline(borderColor: MyColors.transparent),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        validator: validator,
        // initialValue: title,
        style: MyFonts.regular(16),
        textCapitalization: TextCapitalization.sentences,
        maxLength: maxLength ?? (maxLines == 1 ? 45 : 256),
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: (e) => onChanged(e),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (e) =>
            onFieldSubmitted == null ? null : onFieldSubmitted(e),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          contentPadding: EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.skyBlue, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.lightGrey, width: 1),
          ),
          suffixIcon: clearAndEdit == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (clearAndEdit == 1)
                      IconButton(
                        onPressed: () => onTap == null ? null : onTap(1),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.clear),
                      ),
                    if (clearAndEdit == 2)
                      IconButton(
                        onPressed: () => onTap == null ? null : onTap(2),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.edit),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

Widget abBottomBar(BuildContext context, int current, int total) {
  final width = MediaQuery.of(context).size.width;
  final indent = ((width - (gHPadding.left * 2)) / total) * current;
  return Stack(
    alignment: Alignment.bottomLeft,
    children: [
      Divider(height: 0, thickness: 3, color: MyColors.grey),
      AnimatedContainer(
        height: 8,
        width: indent,
        duration: duration,
        color: MyColors.darkBlue,
      ),
    ],
  );
}

Widget abCounts(int current, int total) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Text(
        (current <= 9 ? '0' : '') + '$current',
        style: MyFonts.semiBold(28, color: MyColors.black),
      ),
      Text(
        '/ ${(total <= 9 ? '0' : '')}$total',
        style: MyFonts.semiBold(18, color: MyColors.grey),
      ),
    ],
  );
}

PreferredSize abHeader(
  String title, {
  Function(int)? onTap,
  Widget? center,
  Widget? bottom,
  bool showHome = true,
  bool showBack = true,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
    child: SafeArea(
      child: Container(
        height: double.infinity,
        padding: gHPadding,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: showBack,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainSemantics: true,
                    child: IconButton(
                      onPressed: () => onTap == null ? Get.back() : onTap(1),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: MyColors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: center ??
                        Text(
                          title,
                          style: MyFonts.medium(25),
                          textAlign: TextAlign.center,
                        ),
                  ),
                  Visibility(
                    visible: showHome,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainSemantics: true,
                    child: IconButton(
                      onPressed: () => onTap == null
                          ? Get.to(() => RegistrationProgress())
                          : onTap(2),
                      icon: Icon(
                        Icons.home,
                        size: 30,
                        color: MyColors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom ?? Divider(height: 3, color: MyColors.grey),
          ],
        ),
      ),
    ),
  );
}

PreferredSize abHeaderNew(
  BuildContext context,
  String title, {
  Function(int)? onTap,
  Widget? center,
  Widget? bottom,
  bool showHome = true,
  bool showBack = true,
}) {
  bool isReviewing = Services.shared.completed == "Yes";
  if (isWebApp) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: SafeArea(
        child: Container(
          height: double.infinity,
          padding: gHPadding,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: showBack,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainSemantics: true,
                            child: IconButton(
                              onPressed: () =>
                                  onTap == null ? Get.back() : onTap(1),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: MyColors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            child: center ??
                                Text(
                                  title,
                                  style: MyFonts.medium(25),
                                  textAlign: TextAlign.center,
                                ),
                          ),
                          Visibility(
                            visible: showHome,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainSemantics: true,
                            child: IconButton(
                              onPressed: () => onTap == null
                                  ? (isReviewing
                                      ? Get.offAll(() => RegistrationComplete())
                                      : Get.offAll(
                                          () => RegistrationProgress()))
                                  : onTap(2),
                              icon: Icon(
                                Icons.home,
                                size: 30,
                                color: MyColors.lightBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  ],
                ),
              ),
              bottom ?? Divider(height: 3, color: MyColors.grey),
            ],
          ),
        ),
      ),
    );
  } else {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: SafeArea(
        child: Container(
          height: double.infinity,
          padding: gHPadding,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: showBack,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      maintainSemantics: true,
                      child: IconButton(
                        onPressed: () => onTap == null ? Get.back() : onTap(1),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: MyColors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: center ??
                          Text(
                            title,
                            style: MyFonts.medium(25),
                            textAlign: TextAlign.center,
                          ),
                    ),
                    Visibility(
                      visible: showHome,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      maintainSemantics: true,
                      child: IconButton(
                        onPressed: () => onTap == null
                            ? (isReviewing
                                ? Get.offAll(() => RegistrationComplete())
                                : Get.offAll(() => RegistrationProgress()))
                            : onTap(2),
                        icon: Icon(
                          Icons.home,
                          size: 30,
                          color: MyColors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom ?? Divider(height: 3, color: MyColors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

Widget abRadioButtons(bool? groupValue, Function(bool?) onChanged,
    {bool showIcon = false}) {
  return Row(
    children: [
      Row(
        children: [
          Radio(
            value: true,
            groupValue: groupValue,
            fillColor: MaterialStateProperty.all(MyColors.darkBlue),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (bool? value) => onChanged(value),
          ),
          Text('yes'.tr, style: MyFonts.semiBold(16, color: MyColors.darkBlue)),
          SizedBox(width: 16),
          Radio(
            value: false,
            groupValue: groupValue,
            fillColor: MaterialStateProperty.all(MyColors.darkBlue),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (bool? value) => onChanged(value),
          ),
          Text('no'.tr, style: MyFonts.semiBold(16, color: MyColors.darkBlue)),
        ],
      ),
      Spacer(),
      if (showIcon && groupValue != null)
        Icon(Icons.check_circle, color: MyColors.green),
    ],
  );
}

Widget abWords(String text, String highlight, WrapAlignment? alignment,
    {Color? textColor, double? size}) {
  final allWords = text.split(' ');
  final words = highlight.split(' ');
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        alignment: alignment ?? WrapAlignment.start,
        children: [
          for (var word in allWords)
            Text(
              word + ' ',
              style: words.contains(word)
                  ? MyFonts.bold(size ?? 28,
                      color: textColor ?? MyColors.darkBlue)
                  : MyFonts.regular(size ?? 28,
                      color: textColor ?? MyColors.black),
            ),
        ],
      ),
    ],
  );
}

Widget abAnimatedButton(String title, IconData? rightImage,
    {bool disabled = false, Function()? onTap}) {
  final color = MyColors.white.withAlpha(disabled ? 127 : 255);
  return InkWell(
    onTap: onTap,
    child: Container(
      height: buttonHeight,
      width: double.infinity,
      padding: EdgeInsets.only(left: 4),
      color: MyColors.white,
      child: Container(
        color: MyColors.lightBlue,
        padding: gHPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: MyFonts.regular(24, color: color)),
            Icon(rightImage, color: color, size: 30),
          ],
        ),
      ),
    ),
  );
}

Widget abAnimatedButtonWithFixedWidth(String title, IconData? rightImage,
    {bool disabled = false, double buttonWidth = 200, Function()? onTap}) {
  final color = MyColors.white.withAlpha(disabled ? 127 : 255);
  return InkWell(
    onTap: onTap,
    child: Container(
      height: buttonHeight,
      width: buttonWidth,
      padding: EdgeInsets.only(left: 4),
      color: MyColors.white,
      child: Container(
        color: MyColors.lightBlue,
        padding: gHPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: MyFonts.regular(24, color: color)),
            Icon(rightImage, color: color, size: 30),
          ],
        ),
      ),
    ),
  );
}

Widget abRoundButtonWithFixedWidth(String title,
    {bool disabled = false,
    double buttonWidth = 200,
    double btnHeight = 56,
    Function()? onTap}) {
  final color = MyColors.white.withAlpha(disabled ? 127 : 255);
  return InkWell(
    onTap: onTap,
    //   height: buttonHeight,
    //   width: buttonWidth,
    // color: MyColors.white,
    child: Container(
      height: btnHeight,
      width: buttonWidth,
      decoration: BoxDecoration(
        color: MyColors.lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: MyFonts.regular(18, color: color)),
        ],
      ),
    ),
  );
}

Widget abBottom({
  String? top = '',
  String? bottom = '',
  bool? onlyTopDisabled,
  List<String>? multiple,
  Function(int)? onTap,
}) {
  final isSingleButton = top == null || bottom == null;
  final bottomArrow = (bottom ?? '').isEmpty || bottom == 'back'.tr
      ? Icons.arrow_back_ios_new
      : Icons.arrow_forward_ios;
  final title1 = (top ?? '').isEmpty ? 'proceed'.tr : top!;
  final title2 = (bottom ?? '').isEmpty ? 'back'.tr : bottom!;
  final bottomDisabled = !(onlyTopDisabled ?? true);
  final length = multiple != null
      ? multiple.length + 1
      : isSingleButton
          ? 1
          : 2;
  return GetBuilder(
    init: objABBottom,
    builder: (b) {
      if (objABBottom.hideBottom) {
        return Container();
      }
      return Container(
        height: (length * buttonHeight) + ((length + 1) * 16),
        padding: gHPadding,
        color: MyColors.darkBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (multiple != null)
              for (var i in multiple)
                Column(
                  children: [
                    abAnimatedButton(i, null, onTap: () async {
                      onTap!(multiple.indexOf(i) + 2);
                    }),
                    SizedBox(height: 16),
                  ],
                ),
            if (top != null)
              abAnimatedButton(
                title1,
                Icons.arrow_forward_ios,
                disabled: onlyTopDisabled ?? false,
                onTap: () async {
                  onTap!(0);
                },
              ),
            if (!isSingleButton) SizedBox(height: 16),
            if (bottom != null)
              abAnimatedButton(
                title2,
                bottomArrow,
                disabled: bottomDisabled,
                onTap: () async {
                  bottomDisabled
                      ? null
                      : bottom.isEmpty
                          ? Get.back()
                          : onTap!(1);
                },
              ),
          ],
        ),
      );
    },
  );
}

Widget abBottomNew(
  BuildContext context, {
  String? top = '',
  String? bottom = '',
  bool? onlyTopDisabled,
  List<String>? multiple,
  Function(int)? onTap,
}) {
  final isSingleButton = top == null || bottom == null;
  final bottomArrow = (bottom ?? '').isEmpty || bottom == 'back'.tr
      ? Icons.arrow_back_ios_new
      : Icons.arrow_forward_ios;
  final title1 = (top ?? '').isEmpty ? 'proceed'.tr : top!;
  final title2 = (bottom ?? '').isEmpty ? 'back'.tr : bottom!;
  final bottomDisabled = !(onlyTopDisabled ?? true);
  final length = multiple != null
      ? multiple.length + 1
      : isSingleButton
          ? 1
          : 2;
  final buttonHeightLength = length > 2 ? length : 2;
  if (isWebApp) {
    return GetBuilder(
      init: objABBottom,
      builder: (b) {
        if (objABBottom.hideBottom) {
          return Container();
        }
        return Container(
          height: (buttonHeightLength * buttonHeight) +
              ((buttonHeightLength + 1) * 16),
          padding: gHPadding,
          color: MyColors.darkBlue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (multiple != null)
                        for (var i in multiple)
                          Column(
                            children: [
                              abAnimatedButton(i, null, onTap: () async {
                                onTap!(multiple.indexOf(i) + 2);
                              }),
                              SizedBox(height: 16),
                            ],
                          ),
                      if (top != null)
                        abAnimatedButton(
                          title1,
                          Icons.arrow_forward_ios,
                          disabled: onlyTopDisabled ?? false,
                          onTap: () async {
                            onTap!(0);
                          },
                        ),
                      if (!isSingleButton) SizedBox(height: 16),
                      if (bottom != null)
                        abAnimatedButton(
                          title2,
                          bottomArrow,
                          disabled: bottomDisabled,
                          onTap: () async {
                            bottomDisabled
                                ? null
                                : bottom.isEmpty
                                    ? Get.back()
                                    : onTap!(1);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
            ],
          ),
        );
      },
    );
  } else {
    return GetBuilder(
      init: objABBottom,
      builder: (b) {
        if (objABBottom.hideBottom) {
          return Container();
        }
        return Container(
          height: (length * buttonHeight) + ((length + 1) * 16),
          padding: gHPadding,
          color: MyColors.darkBlue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (multiple != null)
                for (var i in multiple)
                  Column(
                    children: [
                      abAnimatedButton(i, null, onTap: () async {
                        onTap!(multiple.indexOf(i) + 2);
                      }),
                      SizedBox(height: 16),
                    ],
                  ),
              if (top != null)
                abAnimatedButton(
                  title1,
                  Icons.arrow_forward_ios,
                  disabled: onlyTopDisabled ?? false,
                  onTap: () async {
                    onTap!(0);
                  },
                ),
              if (!isSingleButton) SizedBox(height: 16),
              if (bottom != null)
                abAnimatedButton(
                  title2,
                  bottomArrow,
                  disabled: bottomDisabled,
                  onTap: () async {
                    bottomDisabled
                        ? null
                        : bottom.isEmpty
                            ? Get.back()
                            : onTap!(1);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget abBottomRow({
  String? top = '',
  String? bottom = '',
  bool? onlyTopDisabled,
  List<String>? multiple,
  Function(int)? onTap,
}) {
  final isSingleButton = top == null || bottom == null;
  final bottomArrow = (bottom ?? '').isEmpty || bottom == 'back'.tr
      ? Icons.arrow_back_ios_new
      : Icons.arrow_forward_ios;
  final title1 = (top ?? '').isEmpty ? 'proceed'.tr : top!;
  final title2 = (bottom ?? '').isEmpty ? 'back'.tr : bottom!;
  final bottomDisabled = !(onlyTopDisabled ?? true);
  final length = multiple != null
      ? multiple.length + 1
      : isSingleButton
          ? 1
          : 2;
  return GetBuilder(
    init: objABBottom,
    builder: (b) {
      if (objABBottom.hideBottom) {
        return Container();
      }
      return Container(
        height: buttonHeight * 1.5,
        width: double.infinity,
        color: MyColors.darkBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (multiple != null)
              for (var i in multiple)
                Column(
                  children: [
                    abAnimatedButtonWithFixedWidth(i, null, onTap: () async {
                      onTap!(multiple.indexOf(i) + 2);
                    }),
                    SizedBox(width: 16),
                  ],
                ),
            if (top != null)
              abAnimatedButtonWithFixedWidth(
                title1,
                Icons.arrow_forward_ios,
                disabled: onlyTopDisabled ?? false,
                onTap: () async {
                  onTap!(0);
                },
              ),
            if (bottom != null)
              abAnimatedButtonWithFixedWidth(
                title2,
                bottomArrow,
                disabled: bottomDisabled,
                onTap: () async {
                  bottomDisabled
                      ? null
                      : bottom.isEmpty
                          ? Get.back()
                          : onTap!(1);
                },
              ),
          ],
        ),
      );
    },
  );
}

Future abShowAlert(
    BuildContext context, String message, String buttonTitle) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('es'.tr, style: MyFonts.regular(24)),
        content: Text(message, style: MyFonts.regular(17)),
        actions: [
          TextButton(
            child: Text(buttonTitle,
                style: MyFonts.bold(16, color: MyColors.lightBlue)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

Widget abTitle(String title, {Color? color}) =>
    Text(title, style: MyFonts.regular(18, color: color ?? MyColors.black));

Future abShowMessage(String message) async {
  return Get.snackbar(
    'es'.tr,
    message,
    titleText: Text('es'.tr, style: MyFonts.bold(16, color: MyColors.white)),
    messageText:
        Text(message, style: MyFonts.regular(14, color: MyColors.white)),
    borderRadius: 0,
    shouldIconPulse: true,
    onTap: (e) => Get.back(),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.black.withOpacity(0.5),
    leftBarIndicatorColor: MyColors.yellow,
    icon: Icon(Icons.warning_amber_rounded, color: MyColors.yellow),
  );
}

SharedPreferences? localStorage;
Future localStorageInit() async {
  localStorage = await SharedPreferences.getInstance();
  localStorage?.setString('version', versionStr);
}

removeAllSharedPref() async {
  Services.shared.completed = 'No';
  Resume.shared.init();
  await localStorage?.clear();
}

class ResponsiveWidget extends StatelessWidget {
  //Large screen is any screen whose width is more than 1200 pixels
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

//Small screen is any screen whose width is less than 800 pixels
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

//Medium screen is any screen whose width is less than 1200 pixels,
  //and more than 800 pixels
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800 &&
        MediaQuery.of(context).size.width < 1200;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

Widget abMainWidgetWithBottomBarLoadingOverlayScaffoldFormScrollView(
    BuildContext context, bool isLoading, Key formKey,
    {required PreferredSizeWidget appBar,
    required Widget content,
    Widget? bottomBar}) {
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: gHPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: content),
                      ),
                      if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                    ],
                  ),
                ),
              ),
              if (bottomBar != null) bottomBar
            ],
          ),
        ),
      ),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child:
                    SingleChildScrollView(padding: gHPadding, child: content),
              ),
              if (bottomBar != null) bottomBar
            ],
          ),
        ),
      ),
    );
  }
}

Widget abMainWidgetWithLoadingOverlayScaffoldScrollView(
    BuildContext context, bool isLoading,
    {required PreferredSizeWidget appBar, required Widget content}) {
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: abHeaderNew(context, 'Verification'.tr, showHome: false),
        body: SingleChildScrollView(
          padding: gHPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: content),
              ),
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
            ],
          ),
        ),
      ),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(padding: gHPadding, child: content),
      ),
    );
  }
}

Widget abMainWidgetWithLoadingOverlayScaffoldContainer(
    BuildContext context, bool isLoading,
    {required PreferredSizeWidget appBar, required Widget content}) {
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Container(
          padding: gHPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: content),
              ),
              if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
            ],
          ),
        ),
      ),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Container(padding: gHPadding, child: content),
      ),
    );
  }
}

Widget abPinCodeText(BuildContext context, int length,
    {Function(String)? onCompleted,
    required Function(String) onChanged,
    TextEditingController? controller,
    bool readOnly = false}) {
  return PinCodeTextField(
    controller: controller,
    appContext: context,
    pastedTextStyle: MyFonts.bold(32, color: MyColors.darkBlue),
    length: length,
    obscureText: true,
    obscuringCharacter: '*',
    blinkWhenObscuring: true,
    animationType: AnimationType.fade,
    readOnly: readOnly,
    validator: (v) {
      return null;
    },
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(5),
      fieldHeight: 50,
      fieldWidth: 40,
      selectedFillColor: MyColors.white,
      inactiveFillColor: MyColors.white,
      activeFillColor: Colors.white,
      selectedColor: MyColors.darkBlue,
      inactiveColor: MyColors.darkBlue,
      activeColor: MyColors.darkBlue,
    ),
    cursorColor: MyColors.darkBlue,
    animationDuration: Duration(milliseconds: 300),
    enableActiveFill: true,
    keyboardType: TextInputType.number,
    boxShadows: [
      BoxShadow(
        offset: Offset(0, 1),
        color: Colors.black12,
        blurRadius: 10,
      )
    ],
    onCompleted: onCompleted,
    onChanged: onChanged,
    beforeTextPaste: (text) {
      return true;
    },
  );
}

Widget abMainWidgetWithBottomBarLoadingOverlayScaffoldContainer(
    BuildContext context, bool isLoading,
    {required PreferredSizeWidget appBar,
    required Widget content,
    Widget? bottomBar}) {
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: gHPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: content),
                    ),
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  ],
                ),
              ),
            ),
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: Container(padding: gHPadding, child: content),
            ),
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  }
}

Widget abMainWidgetWithBottomBarLoadingOverlayScaffoldScrollView(
    BuildContext context, bool isLoading,
    {required PreferredSizeWidget appBar,
    required Widget content,
    Widget? bottomBar}) {
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: gHPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: content),
                    ),
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  ],
                ),
              ),
            ),
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(padding: gHPadding, child: content),
            ),
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  }
}

Widget abMainWidgetWithBottomBarLoadingOverlayScaffold(
    BuildContext context, bool isLoading,
    {required PreferredSizeWidget appBar,
    required Widget content,
    Widget? bottomBar}) {
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 2,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: content),
                  ),
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                ],
              ),
            ),
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(child: content),
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  }
}

Widget abMainWidgetWithBottomBarScaffoldScrollView(BuildContext context,
    {required PreferredSizeWidget appBar,
    required Widget content,
    Widget? bottomBar}) {
  if (isWebApp) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: gHPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 2,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: content),
                  ),
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                ],
              ),
            ),
          ),
          if (bottomBar != null) bottomBar
        ],
      ),
    );
  } else {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(padding: gHPadding, child: content),
          ),
          if (bottomBar != null) bottomBar
        ],
      ),
    );
  }
}

Widget abMainWidgetWithBottomBarLoadingOverlayScaffoldBottomTitle(
    BuildContext context, bool isLoading,
    {required PreferredSizeWidget appBar,
    required Widget content,
    required Widget bottomTitle,
    Widget? bottomBar}) {
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 2,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: content),
                  ),
                  if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                ],
              ),
            ),
            bottomTitle,
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(child: content),
            bottomTitle,
            if (bottomBar != null) bottomBar
          ],
        ),
      ),
    );
  }
}

PreferredSize abV2AppBar(
  BuildContext context,
  String title, {
  Function(int)? onTap,
  bool showBack = false,
  bool showIcon = false,
}) {
  if (isWebApp) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: SafeArea(
        child: Container(
          height: double.infinity,
          padding: gHPadding,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: showBack,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainSemantics: true,
                            child: IconButton(
                              onPressed: () =>
                                  onTap == null ? Get.back() : onTap(1),
                              icon: Icon(
                                Icons.arrow_back,
                                color: MyColors.v2Primary,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              title,
                              style:
                                  MyFonts.light(20, color: MyColors.v2Primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Visibility(
                            visible: showIcon,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainSemantics: true,
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.menu,
                                color: MyColors.v2Primary,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!ResponsiveWidget.isSmallScreen(context)) Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  } else {
    final MyThemeColors myColors =
        Theme.of(context).extension<MyThemeColors>()!;
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: SafeArea(
        child: Container(
          color: myColors.canvasBackground,
          height: double.infinity,
          padding: gHPadding,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned.fill(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: showBack,
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        maintainSemantics: true,
                        child: IconButton(
                          onPressed: () =>
                              onTap == null ? Get.back() : onTap(1),
                          icon: Icon(
                            Icons.arrow_back,
                            color: MyColors.v2Primary,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: MyFonts.medium(25, color: MyColors.v2Primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Visibility(
                        visible: showIcon,
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        maintainSemantics: true,
                        child: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.menu,
                            color: MyColors.v2Primary,
                            size: 30,
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

BottomNavigationBar abV2BottomNavigationBarA(
    int currentIndex, Function(int)? onTap) {
  return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 28,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          label: 'Work',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: MyColors.v2Primary,
      onTap: onTap);
}

BottomNavigationBar abV2BottomNavigationBarB(
    int currentIndex, Function(int)? onTap) {
  return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 28,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          label: 'Work',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage('lib/images/v2/home_icon.png'),
            height: 32,
            width: 32,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: MyColors.v2Primary,
      onTap: onTap);
}

void abV2GotoBottomNavigation(toIndex, excludeIndex) {
  if (toIndex == excludeIndex) return;
  switch (toIndex) {
    case 0:
      Get.to(() => V2HomeView());
      break;
    case 1:
      Get.to(() => V2WorkView());
      break;
    case 2:
      Get.to(() => V2ProfileView());
      break;
    case 3:
      Get.to(() => V2NotificationsView());
      break;
    case 4:
      Get.to(() => V2SettingsView());
      break;
    default:
  }
}

void abV2GotoBottomNavigationForHomePage(toIndex, excludeIndex) {
  if (toIndex == excludeIndex) return;
  switch (toIndex) {
    case 0:
      Get.to(() => V2WorkView());
      break;
    case 1:
      Get.to(() => V2ProfileView());
      break;
    case 2:
      Get.to(() => V2HomeView());
      break;
    case 3:
      Get.to(() => V2NotificationsView());
      break;
    case 4:
      Get.to(() => V2SettingsView());
      break;
    default:
  }
}

Widget abV2MainWidgetWithLoadingOverlayScaffoldScrollView(
    BuildContext context, bool isLoading,
    {required PreferredSizeWidget appBar,
    required Widget content,
    Widget? bottomNavigationBar}) {
  final MyThemeColors myColors = Theme.of(context).extension<MyThemeColors>()!;
  if (isWebApp) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
          appBar: appBar,
          body: Container(
              color: myColors.canvasBackground,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!ResponsiveWidget.isSmallScreen(context))
                            Spacer(),
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 2,
                            child: Container(child: content),
                          ),
                          if (!ResponsiveWidget.isSmallScreen(context))
                            Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          bottomNavigationBar: bottomNavigationBar),
    );
  } else {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors
            .darkBlue), // set the background color of the loading circle
      ),
      child: Scaffold(
          appBar: appBar,
          body: Container(
              color: myColors.canvasBackground,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: content),
                  ),
                ],
              )),
          bottomNavigationBar: bottomNavigationBar),
    );
  }
}

Widget abV2PrimaryButton(String title,
    {required Function() onTap, bool fullWidth = false, bool success = false}) {
  if (fullWidth) {
    return TextButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(44)),
          backgroundColor: MaterialStateProperty.all<Color>(
              success ? MyColors.v2Green : MyColors.v2Primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(
                      color: success ? MyColors.v2Green : MyColors.v2Primary))),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
      child: Text(title, style: MyFonts.bold(11, color: MyColors.white)),
      onPressed: onTap,
    );
  } else {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(MyColors.v2Primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: MyColors.v2Primary))),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
                horizontal: 25, vertical: 5), // Modify these values
          )),
      child: Text(title, style: MyFonts.regular(15, color: MyColors.white)),
      onPressed: onTap,
    );
  }
}

Widget abV2OutlineButton(String title,
    {required Function() onTap, bool fullWidth = false, bool success = false}) {
  if (fullWidth) {
    return TextButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(44)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(
                      color: success ? MyColors.v2Green : MyColors.v2Primary))),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
      child: Text(title, style: MyFonts.regular(14, color: MyColors.v2Primary)),
      onPressed: onTap,
    );
  } else {
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: MyColors.v2Primary))),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 32, vertical: 16))),
      child: Text(title, style: MyFonts.regular(16, color: MyColors.v2Primary)),
      onPressed: onTap,
    );
  }
}

Widget abV2IconButton(
  String title, {
  required Function() onTap,
  bool fullWidth = false,
  bool success = false,
  Widget? icon,
}) {
  if (fullWidth) {
    return TextButton.icon(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size.fromHeight(44)),
        backgroundColor: MaterialStateProperty.all<Color>(
            success ? MyColors.v2Green : MyColors.v2Primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
                color: success ? MyColors.v2Green : MyColors.v2Primary),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      ),
      icon: Align(
        alignment: Alignment.centerRight,
        child: icon ?? SizedBox(),
      ),
      label: Text(
        title,
        style: MyFonts.regular(14, color: MyColors.white),
        textAlign: TextAlign.center,
      ),
      onPressed: onTap,
    );
  } else {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(MyColors.v2Primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: MyColors.v2Primary),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      ),
      icon: Align(
        alignment: Alignment.centerRight,
        child: icon ?? SizedBox(),
      ),
      label: Text(
        title,
        style: MyFonts.regular(16, color: MyColors.white),
        textAlign: TextAlign.center,
      ),
      onPressed: onTap,
    );
  }
}

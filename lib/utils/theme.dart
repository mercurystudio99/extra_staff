import 'package:flutter/material.dart';
import 'package:extra_staff/utils/constants.dart';

@immutable
class MyThemeColors extends ThemeExtension<MyThemeColors> {
  const MyThemeColors({
    required this.primary,
    required this.canvasBackground,
    required this.itemContainerBackground,
  });

  final Color? primary;
  final Color? canvasBackground;
  final Color? itemContainerBackground;

  @override
  MyThemeColors copyWith(
      {Color? primary,
      Color? canvasBackground,
      Color? itemContainerBackground}) {
    return MyThemeColors(
      primary: primary ?? this.primary,
      canvasBackground: canvasBackground ?? this.canvasBackground,
      itemContainerBackground:
          itemContainerBackground ?? this.itemContainerBackground,
    );
  }

  @override
  MyThemeColors lerp(ThemeExtension<MyThemeColors>? other, double t) {
    if (other is! MyThemeColors) {
      return this;
    }
    return MyThemeColors(
      primary: Color.lerp(primary, other.primary, t),
      canvasBackground: Color.lerp(canvasBackground, other.canvasBackground, t),
      itemContainerBackground:
          Color.lerp(itemContainerBackground, other.itemContainerBackground, t),
    );
  }

  // Optional
  @override
  String toString() =>
      'MyThemeColors(primary: $primary, canvasBackground: $canvasBackground, itemContainerBackground: $itemContainerBackground)';
}

class MyThemes {
  //light theme
  static final light = ThemeData(useMaterial3: true)
      .copyWith(extensions: <ThemeExtension<dynamic>>[
    const MyThemeColors(
        primary: MyColors.v2Primary,
        canvasBackground: MyColors.v2Background,
        itemContainerBackground: MyColors.white),
  ]);

//dark theme
  static final dark = ThemeData.dark(useMaterial3: true)
      .copyWith(extensions: <ThemeExtension<dynamic>>[
    const MyThemeColors(
        primary: MyColors.v2Primary,
        canvasBackground: Color(0xFF404040),
        itemContainerBackground: Color(0xFF101010)),
  ]);
}

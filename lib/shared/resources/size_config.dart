import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/widget/check_view_widget.dart';
import 'manager_values.dart';

class SizeConfig {
  // static late MediaQuery _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    // _mediaQueryData = MediaQuery;
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    orientation = MediaQuery.orientationOf(context);
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  return inputHeight.h;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  return inputWidth.w;
}

// This is where the magic happens.
// This functions are responsible to make UI responsive across all the mobile devices.
final FlutterView flutterView =
    WidgetsBinding.instance.platformDispatcher.views.single;
final Size size = flutterView.physicalSize / flutterView.devicePixelRatio;
// Caution! If you think these are static values and are used to build a static UI,  you mustn’t.
// These are the Viewport values of your Figma Design.
// These are used in the code as a reference to create your UI Responsively.
const num FIGMA_DESIGN_WIDTH = 428;
const num FIGMA_DESIGN_HEIGHT = 926;
const num FIGMA_DESIGN_STATUS_BAR = 0;

///This method is used to get device viewport width.
get width {
  return size.width;
}

///This method is used to get device viewport height.
get height {
  num statusBar = MediaQueryData.fromView(flutterView).viewPadding.top;
  num screenHeight = size.height - statusBar;
  return screenHeight;
}

///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
double getHorizontalSize(double px) {
  return ((px * width) / FIGMA_DESIGN_WIDTH);
}

///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
double getVerticalSize(double px) {
  return ((px * height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR));
}

///This method is used to set smallest px in image height and width
double getSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

///This method is used to set text font size according to Viewport
double getFontSize(double px) {
  return getSize(px);
}

///This method is used to set padding responsively
EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? vertical,
  double? horizontal,
  bool isContent = true,
}) {
  return isContent
      ? _getMarginOrPaddings(
          all: all,
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          horizontal: horizontal,
          vertical: vertical,
        )
      : _getMarginOrPadding(
          all: all,
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          horizontal: horizontal,
          vertical: vertical,
        );
}

///This method is used to set margin responsively
EdgeInsetsGeometry getMargin({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? vertical,
  double? horizontal,
  bool isContent = true,
}) {
  return isContent
      ? _getMarginOrPaddings(
          all: all,
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          horizontal: horizontal,
          vertical: vertical,
        )
      : _getMarginOrPadding(
          all: all,
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          horizontal: horizontal,
          vertical: vertical,
        );
}

///This method is used to get padding or margin responsively
EdgeInsetsGeometry _getMarginOrPaddings({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? vertical,
  double? horizontal,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return vertical != null || horizontal != null
      ? EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        )
      : EdgeInsets.only(
          left: left ?? 0,
          top: top ?? 0,
          right: right ?? 0,
          bottom: bottom ?? 0,
        );
}

EdgeInsetsGeometry _getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? vertical,
  double? horizontal,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return vertical != null || horizontal != null
      ? EdgeInsets.symmetric(
          horizontal: horizontal != null ? horizontal.w : 0.w,
          vertical: vertical != null ? vertical.h : 0.h,
        )
      : EdgeInsets.only(
          left: left != null ? left.w : 0.w,
          top: top != null ? top.h : 0.h,
          right: right != null ? right.w : 0.w,
          bottom: bottom != null ? bottom.h : 0.h,
        );
}

EdgeInsetsGeometry addPaddingForContent(
    {required DeviceScreenType deviceScreenType, bool? isBottomSheet}) {
  return getMargin(
    isContent: deviceScreenType == DeviceScreenType.Mobile,
    vertical: isBottomSheet == true ? 0 : AppPadding.p16,
    horizontal: deviceScreenType == DeviceScreenType.Desktop
        ? AppPadding.p88
        : deviceScreenType == DeviceScreenType.Tablet
            ? AppPadding.p40
            : isBottomSheet == true
                ? 0
                : AppPadding.p24,
  );
}

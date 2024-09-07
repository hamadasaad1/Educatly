import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'IconWithContainer.dart';
import 'check_view_widget.dart';

Future<dynamic> buildSmartMenuWidget({
  Alignment? alignment,
  double? width,
  required Widget menuContent,
  bool withAppBar = true,
  DeviceScreenType deviceScreenType = DeviceScreenType.Mobile,
}) async {
  var result = await SmartDialog.show(
    animationType: alignment == Alignment.center
        ? SmartAnimationType.centerFade_otherSlide
        : SmartAnimationType.centerScale_otherSlide,
    alignment: alignment ?? Alignment.centerRight,
    backDismiss: true,
    builder: (_) => SizedBox(
      width: width ??
          (deviceScreenType == DeviceScreenType.Mobile
              ? ScreenUtil().screenWidth * 1
              : deviceScreenType == DeviceScreenType.Tablet
                  ? ScreenUtil().screenWidth * .6
                  : ScreenUtil().screenWidth * .35),
      child: !withAppBar
          ? menuContent
          : Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconWithContainer(
                      icon: Icons.close,
                      btnFunc: () => SmartDialog.dismiss(),
                    ),
                    Expanded(child: menuContent),
                  ],
                ),
              ),
            ),
    ),
  );
  return result;
}

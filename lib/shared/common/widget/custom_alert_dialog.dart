import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_manager.dart';
import '../../resources/manager_values.dart';
import 'check_view_widget.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget content;
  final DeviceScreenType? deviceScreenType;
  final bool isFullScreen;
  final Color? backgroundColor;

  const CustomAlertDialog({
    required this.content,
    this.isFullScreen = false,
    this.backgroundColor,
    this.deviceScreenType = DeviceScreenType.Mobile,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: backgroundColor ?? ColorManager.background,
        // contentPadding: EdgeInsets.zero,

        insetPadding: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: deviceScreenType == DeviceScreenType.Desktop
                ? AppPadding.p80.w
                : deviceScreenType == DeviceScreenType.Tablet
                    ? AppPadding.p32.w
                    : isFullScreen
                        ? 0
                        : AppPadding.p16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        child: content);
  }
}

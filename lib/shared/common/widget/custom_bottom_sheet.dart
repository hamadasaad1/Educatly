import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/size_config.dart';
import 'check_view_widget.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget child;
  final DeviceScreenType? deviceScreenType;

  const CustomBottomSheet({
    required this.child,
    this.deviceScreenType = DeviceScreenType.Mobile,
  });

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0.0, (1 - _animation.value) * MediaQuery.of(context).size.height),
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              decoration: const BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              margin: getPadding(
                  horizontal:
                      widget.deviceScreenType == DeviceScreenType.Desktop
                          ? AppPadding.p80.w
                          : widget.deviceScreenType == DeviceScreenType.Tablet
                              ? AppPadding.p32.w
                              : 0),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/size_config.dart';
import '../../resources/styles_manager.dart';

enum ToastType {
  wrong,
  error,
  success,
  normal,
}

class CustomToast extends StatelessWidget {
  const CustomToast({
    Key? key,
    this.type = ToastType.normal,
    required this.msg,
  }) : super(key: key);

  final String msg;
  final ToastType type;

  Color _getColor() {
    switch (type) {
      case ToastType.wrong:
        return ColorManager.missing;
      case ToastType.error:
        return ColorManager.error;
      case ToastType.success:
        return ColorManager.success;
      case ToastType.normal:
        return ColorManager.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: getPadding(bottom: 30, right: 30, left: 30, isContent: false),
        padding: getPadding(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: _getColor(),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //icon
              // Container(
              //   margin: EdgeInsets.only(right: 15),
              //   child: Icon(Icons.info_outline, color: Colors.white),
              // ),

              //msg
              Expanded(
                  child: Text(msg,
                      style: getRegularStyle(color: ColorManager.white))),
            ]),
      ),
    );
  }
}

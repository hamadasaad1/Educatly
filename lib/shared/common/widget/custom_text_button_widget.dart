import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';

class CustomTextButtonWidget extends StatelessWidget {
  const CustomTextButtonWidget({
    super.key,
    required this.text,
    required this.actionText,
    this.onPress,
    this.color,
    this.isUnderLined,
    this.isBold,
  });

  final String text;
  final String actionText;
  final Function? onPress;
  final Color? color;
  final bool? isUnderLined;
  final bool? isBold;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPress as void Function()?,
        child: RichText(
            text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: text, style: getRegularStyle(color: ColorManager.grey)),
            TextSpan(
              text: actionText,
              style: TextStyle(
                fontWeight:
                    isBold == true ? FontWeight.bold : FontWeight.normal,
                color: color ?? ColorManager.primary,
                fontSize: isBold == true ? FontSize.s16 : FontSize.s14,
                fontFamily: "Poppins",
                decoration: isUnderLined == true
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ],
        )),
      ),
    );
  }
}

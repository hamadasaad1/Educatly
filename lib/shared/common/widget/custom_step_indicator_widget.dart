import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';

class CustomStepIndicatorWidget extends StatelessWidget {
  final Function()? onTap;

  const CustomStepIndicatorWidget({
    super.key,
    required this.stepName,
    required this.isActive,
    this.onTap,
  });

  final String stepName;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepName,
              style: getRegularStyle(
                color: isActive
                    ? ColorManager.primary
                    : ColorManager.coolGray.withOpacity(0.8),
                fontSize: FontSize.s14,
              ),
            ),
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: isActive
                    ? ColorManager.primary
                    : ColorManager.coolGray.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

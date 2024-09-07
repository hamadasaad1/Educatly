import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/size_config.dart';
import 'custom_image_widget.dart';

class ContainerWithSvg extends StatelessWidget {
  const ContainerWithSvg({
    super.key,
    required this.svgName,
    required this.color,
    this.hasBorder = false,
  });

  final String svgName;
  final Color color;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(all: 6),
      decoration: BoxDecoration(
        color: hasBorder ? ColorManager.white : color.withOpacity(0.1),
        border: hasBorder
            ? Border.all(color: ColorManager.neutralGray100, width: 0.75)
            : null,
        borderRadius: BorderRadius.circular(AppSize.s4),
      ),
      child: CustomSvgImage(
        imageName: svgName,
        color: color,
        width: 16,
      ),
    );
  }
}

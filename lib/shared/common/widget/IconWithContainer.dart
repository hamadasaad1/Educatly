import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';

class IconWithContainer extends StatelessWidget {
  IconWithContainer(
      {super.key,
      required this.icon,
      this.color,
      this.size,
      required this.btnFunc});

  final IconData icon;
  final double? size;
  final Color? color;
  final VoidCallback btnFunc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: btnFunc,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              color != null ? color?.withOpacity(0.08) : ColorManager.greySold,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color ?? ColorManager.black,
          size: size,
        ),
      ),
    );
  }
}

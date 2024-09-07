import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'manager_values.dart';

OutlineInputBorder _getInputBorderStyle(double weight, Color color, {double radius = AppSize.s4}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(
      color: color,
      width: weight,
    ),
  );
}

//regular style for text fields
OutlineInputBorder getRegularBorderStyle(
    {double weight = 0.5, Color color = ColorManager.lightGrey, double radius = AppSize.s4} ) {
  return _getInputBorderStyle(weight, color, radius: radius);
}

//regular style [For containers]
Border getRegularBorderContainerStyle(
    {double weight = 0.5, Color color = ColorManager.lightGrey,}) {
  return Border.all(width: weight, color: color);
}

//Focused style
OutlineInputBorder getFocusedBorderStyle(
    {double weight = 0.5, Color color = ColorManager.coolGray, double radius = AppSize.s4}) {
  return _getInputBorderStyle(weight, color, radius: radius);
}

//error style
OutlineInputBorder getErroredBorderStyle(
    {double weight = 1, Color color = ColorManager.danger, double radius = AppSize.s4}) {
  return _getInputBorderStyle(weight, color, radius: radius);
}

//fouced error style
OutlineInputBorder getFocusedErroredBorderStyle(
    {double weight = 1.3, Color color = ColorManager.danger, double radius = AppSize.s4}) {
  return _getInputBorderStyle(weight, color, radius: radius);
}

//No border style
OutlineInputBorder getNoBorderStyle(
    {double weight = 0.0, Color color = Colors.transparent, double radius = AppSize.s4}) {
  return _getInputBorderStyle(weight, color, radius: radius);
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'color_manager.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color,
    {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? FontConstants.fontFamily,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}

//regular style
TextStyle getRegularStyle(
    {double fontSize = FontSize.s16, Color color = ColorManager.textColor}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

//medium style
TextStyle getMediumStyle(
    {double fontSize = FontSize.s16, Color color = ColorManager.textColor}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

//light style
TextStyle getLightStyle(
    {double fontSize = FontSize.s16, Color color = ColorManager.textColor}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

//bold style
TextStyle getBoldStyle(
    {double fontSize = FontSize.s16, Color color = ColorManager.textColor}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}

//Black style
TextStyle getBlackStyle(
    {double fontSize = FontSize.s16, Color color = ColorManager.textColor}) {
  return _getTextStyle(fontSize, FontWeightManager.black, color);
}

//semiBold style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s16, Color color = ColorManager.textColor}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}

//textField hint style
TextStyle getHintStyle(
    {double fontSize = FontSize.s14, Color color = ColorManager.gray80}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

//textField error style
TextStyle getErrorTextStyle(
    {double fontSize = FontSize.s15, Color color = ColorManager.danger}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

//app bar text title style
TextStyle getAppBarTitleStyle(
    {double fontSize = FontSize.s24,
    Color color = ColorManager.textHeaderColor}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

//regular style
TextStyle getReceiptStyle(
    {double fontSize = FontSize.s16,
    Color color = ColorManager.textColor,
    FontWeight fontWeight = FontWeightManager.regular}) {
  return _getTextStyle(fontSize, fontWeight, color, fontFamily: "Monaco");
}

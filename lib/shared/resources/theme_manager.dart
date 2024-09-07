import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'manager_values.dart';
import 'styles_manager.dart';

ThemeData getAppTheme() {
  return ThemeData(
    //main color
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    disabledColor: ColorManager.grey,
    colorScheme: const ColorScheme.light(
        secondary: ColorManager.coolGray, primary: ColorManager.primary),
    splashColor: ColorManager.lightPrimary,
    //this color named ripple effect show this color when click in bottom
    //Card theme
    cardTheme: const CardTheme(
        color: ColorManager.white,
        shadowColor: ColorManager.grey,
        elevation: AppSize.s4),
    //app bar Theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.primary,
      elevation: AppSize.s4,
      shadowColor: ColorManager.lightPrimary,
      titleTextStyle: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s16,
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ColorManager.white,
    ),

    //bottom theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: ColorManager.grey,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.lightPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
          color: ColorManager.white,
          fontSize: FontSize.s18,
        ),
        backgroundColor: ColorManager.primary,
        padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p16, horizontal: AppPadding.p8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSize.s4,
          ),
        ),
      ),
    ),

    //text theme
    textTheme: TextTheme(
        headline1: getSemiBoldStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s16),
        bodyText1: getRegularStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s14),
        subtitle1:
            getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s16),
        caption: getRegularStyle(
          color: ColorManager.grey,
        )),

    //input decoration theme

    inputDecorationTheme: InputDecorationTheme(
      //content padding
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppPadding.p8, horizontal: AppPadding.p16),
      hintStyle:
          getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
      labelStyle:
          getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),
      errorStyle: getRegularStyle(color: ColorManager.danger),

      border: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.transparent,
      )),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.danger, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/color_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/styles_manager.dart';
import 'text_filed_widget.dart';

class TextFieldWithTitle extends StatelessWidget {
  TextFieldWithTitle({
    Key? key,
    required this.fNameController,
    required this.fieldName,
    required this.hintText,
    this.inputType,
    this.charNumber,
    this.isPIN,
    this.isClickable,
    this.textStyle,
    this.suffixIcon,
    this.callback,
    this.isPassword = false,
    this.isSecure = false,
    this.isDense = true,
    this.isSkipValidate = false,
    this.showPassword,
    this.isPhoneKeyboard = false,
    this.isNumberKeyboard = false,
    this.controller,
    this.color,
    this.fontSize = 16,
    this.isEmailKeyboard = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.autovalidateMode,
    this.validate,
    this.onChangedCallback,
    this.paddingBottom,
    this.onSubmittedCallback,
    this.textInputType,
    this.inputFormatters,
    this.focusNode,
    this.isCardNumberField = false,
  }) : super(key: key);

  final TextEditingController fNameController;
  final String fieldName;
  final String hintText;
  final TextInputType? inputType;
  final int? charNumber;
  final double? paddingBottom;
  final bool? isPIN;
  final bool? isSecure;
  final bool? isClickable;
  final Widget? suffixIcon;
  final TextStyle? textStyle;

  Function? callback;
  bool isPassword;
  bool isDense;
  bool isSkipValidate;
  Function? showPassword;
  bool? isPhoneKeyboard;

  bool? isNumberKeyboard;
  TextEditingController? controller;

  Color? color;
  TextInputType? textInputType;
  double fontSize;
  Widget? prefixIcon;
  bool? isEmailKeyboard;
  int? maxLines;
  List<TextInputFormatter>? inputFormatters;
  FocusNode? focusNode;
  bool? isCardNumberField;
  AutovalidateMode? autovalidateMode;
  String? Function(String?)? validate;
  Function(String)? onChangedCallback;
  Function(String)? onSubmittedCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: getRegularStyle(color: ColorManager.coolGray),
        ),
        const SizedBox(
          height: AppPadding.p8,
        ),
        CustomTextField(
          hintText: hintText,
          controller: fNameController,
          textInputType: inputType,
          charNumber: charNumber,
          isPIN: isPIN,
          focusNode: focusNode,
          textStyle: textStyle,
          autovalidateMode: autovalidateMode,
          callback: callback,
          color: color,
          fontSize: fontSize,
          isCardNumberField: isCardNumberField ?? false,
          isDense: isDense,
          isEmailKeyboard: isEmailKeyboard ?? false,
          isNumberKeyboard: isNumberKeyboard ?? false,
          isPassword: isPassword,
          isSecure: isSecure ?? false,
          isPhoneKeyboard: isPhoneKeyboard ?? false,
          isSkipValidate: isSkipValidate,
          maxLines: maxLines ?? 1,
          onChangedCallback: onChangedCallback,
          onSubmittedCallback: onSubmittedCallback,
          prefixIcon: prefixIcon,
          inputFormatters: inputFormatters,
          showPassword: showPassword,
          validate: validate,
          isClickable: isClickable,
          suffixIcon: suffixIcon,
        ),
        SizedBox(height: paddingBottom ?? AppPadding.p24),
      ],
    );
  }
}

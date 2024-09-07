import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/assets_manager.dart';
import '../../resources/border_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/styles_manager.dart';
import 'custom_image_widget.dart';

class CustomTextField extends StatefulWidget {
  String hintText;
  Function? callback;
  bool isPassword;
  bool isDense;
  bool isSkipValidate;
  Function? showPassword;
  final bool isSecure;
  bool isPhoneKeyboard;
  bool? isClickable;
  bool isNumberKeyboard;
  TextEditingController? controller;
  Widget? suffixIcon;
  Color? color;
  TextInputType? textInputType;
  double fontSize;
  double borderRadius;
  Widget? prefixIcon;
  bool isEmailKeyboard;
  int maxLines;
  int? charNumber;
  bool? isPIN;
  List<TextInputFormatter>? inputFormatters;
  bool isCardNumberField;
  AutovalidateMode? autovalidateMode;
  String? Function(String?)? validate;
  Function(String)? onChangedCallback;
  Function(String)? onSubmittedCallback;
  final TextStyle? textStyle;
  bool disabledBorder;
  FocusNode? focusNode;

  CustomTextField({
    super.key,
    required this.hintText,
    this.callback,
    this.isPassword = false,
    this.isDense = true,
    this.isSkipValidate = false,
    this.isSecure = false,
    this.showPassword,
    this.isPhoneKeyboard = false,
    this.isClickable,
    this.isNumberKeyboard = false,
    this.controller,
    this.suffixIcon,
    this.textStyle,
    this.inputFormatters,
    this.color,
    this.fontSize = 16,
    this.isEmailKeyboard = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.autovalidateMode,
    this.validate,
    this.onChangedCallback,
    this.onSubmittedCallback,
    this.textInputType,
    this.charNumber,
    this.isCardNumberField = false,
    this.isPIN,
    this.borderRadius=AppMargin.m4,
    this.focusNode,
    this.disabledBorder = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _passwordVisibility;

  @override
  void initState() {
    _passwordVisibility = !widget.isSecure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return textField();
  }

  TextFormField textField() {
    return TextFormField(
      enabled: widget.isClickable,
      style: widget.textStyle ?? getRegularStyle(color: ColorManager.black),
      controller: widget.controller,
      // autofocus: false,
      autovalidateMode: widget.autovalidateMode,
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      textAlignVertical: TextAlignVertical.center,
      maxLength: widget.charNumber,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        counterText: "",
        disabledBorder: widget.disabledBorder
            ? getNoBorderStyle(radius:widget.borderRadius)
            : getRegularBorderStyle( radius:widget.borderRadius),
        focusedBorder: widget.disabledBorder
            ? getNoBorderStyle( radius:widget.borderRadius)
            : getFocusedBorderStyle( radius:widget.borderRadius),
        enabledBorder: widget.disabledBorder
            ? getNoBorderStyle( radius:widget.borderRadius)
            : getRegularBorderStyle( radius:widget.borderRadius),
        errorBorder: widget.disabledBorder
            ? getNoBorderStyle( radius:widget.borderRadius)
            : getErroredBorderStyle(  radius:widget.borderRadius),
        focusedErrorBorder: widget.disabledBorder
            ? getNoBorderStyle( radius:widget.borderRadius)
            : getFocusedErroredBorderStyle(  radius:widget.borderRadius),
        errorStyle: getErrorTextStyle(fontSize: FontSize.s14),
        errorMaxLines: 3,
        hintStyle: getHintStyle(),
        hintText: widget.hintText,
        fillColor: widget.isClickable == false
            ? ColorManager.white.withOpacity(0.1)
            : widget.color ?? Colors.white,
        filled: true,
        // suffixIcon:
        //     // isPassword
        //     //     ? IconButton(
        //     //         icon: CustomSvgImage(
        //     //             imageName: isDense
        //     //                 ? Assets.assetsSvgsHidePassword
        //     //                 : Assets.assetsSvgsShowPassword),
        //     //         onPressed: showPassword as void Function()?)
        //     //     :
        //
        //     widget.suffixIcon,
        suffixIcon: getSuffixIcon(),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p14, horizontal: AppPadding.p8),
                child: widget.prefixIcon,
              )
            : null,
      ),
      textInputAction: TextInputAction.done,
      keyboardType: widget.textInputType ??
          (widget.isEmailKeyboard
              ? TextInputType.emailAddress
              : widget.isNumberKeyboard
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : widget.isPhoneKeyboard
                      ? TextInputType.phone
                      : TextInputType.text),
      // obscureText: widget.isPassword ? widget.isDense : false,
      obscureText: !_passwordVisibility,
      onSaved: (value) {
        if (widget.callback != null) widget.callback!(value);
      },
      onChanged: widget.onChangedCallback,
      onFieldSubmitted: (value) {
        if (widget.onSubmittedCallback != null)
          widget.onSubmittedCallback!(value);
      },
      validator: widget.validate ??
          (String? arg) {
            if (widget.isSkipValidate) return null;

            if (widget.isEmailKeyboard ||
                widget.textInputType == TextInputType.emailAddress) {
              String p =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

              RegExp regExp = RegExp(p);
              if (arg == null || arg.isEmpty) return "Email field is required";
              if (!regExp.hasMatch(arg!)) {
                return 'Invalid Email Format';
              }
            }

            if (arg!.trim().isEmpty || arg.trim().length < 3) {
              return widget.hintText;
            } else {
              return null;
            }
          },
    );
  }

  Widget? getSuffixIcon() {
    return widget.isSecure ? getPasswordSuffixIcon() : widget.suffixIcon;
  }

  Widget? getPasswordSuffixIcon() {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: CustomSvgImage(
          imageName: _passwordVisibility
              ? Assets.assetsSvgHidePassword
              : Assets.assetsSvgShowPassword),
      color: Colors.white,
      splashColor: Colors.transparent,
      onPressed: () {
        setState(() {
          _passwordVisibility = !_passwordVisibility;
        });
      },
    );
  }
}

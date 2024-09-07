import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/size_config.dart';
import '../../resources/styles_manager.dart';
import 'button_widget.dart';

class KeyPad extends StatelessWidget {
  double buttonSize = 62.0;
  final TextEditingController padTextController;
  final Function onChange;
  final Function onSubmit;
  bool isPinLogin = false;
  double? paymentDue;

  KeyPad(
      {required this.onChange,
      required this.onSubmit,
      required this.padTextController,
      this.isPinLogin = false,
      this.paymentDue});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isPinLogin ? ColorManager.white : null,
      padding:
          isPinLogin ? getPadding(horizontal: AppPadding.p24) : EdgeInsets.zero,
      margin: isPinLogin
          ? EdgeInsets.zero
          : getPadding(left: 16, right: 16, isContent: false),
      child: isPinLogin
          ? ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                const SizedBox(height: AppPadding.p16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buttonWidget('1'),
                    const SizedBox(width: AppPadding.p16),
                    buttonWidget('2'),
                    const SizedBox(width: AppPadding.p16),
                    buttonWidget('3'),
                  ],
                ),
                const SizedBox(height: AppPadding.p8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buttonWidget('4'),
                    const SizedBox(width: AppPadding.p16),
                    buttonWidget('5'),
                    const SizedBox(width: AppPadding.p16),
                    buttonWidget('6'),
                  ],
                ),
                const SizedBox(height: AppPadding.p8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buttonWidget('7'),
                    const SizedBox(width: AppPadding.p16),
                    buttonWidget('8'),
                    const SizedBox(width: AppPadding.p16),
                    buttonWidget('9'),
                  ],
                ),
                const SizedBox(height: AppPadding.p8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    iconButtonWidget(Icons.backspace_outlined, () {
                      if (padTextController.text.isNotEmpty) {
                        padTextController.text = padTextController.text
                            .substring(0, padTextController.text.length - 1);
                      }
                      onChange(padTextController.text);
                    }),
                    const SizedBox(width: AppPadding.p16),
                    buttonWidget('0'),
                    const SizedBox(width: AppPadding.p16),
                    iconButtonWidget(Icons.clear, () {
                      if (padTextController.text.isNotEmpty) {
                        padTextController.clear();
                      }
                      onChange(padTextController.text);
                    }),
                  ],
                ),
                const SizedBox(height: AppPadding.p16),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                  child: CustomButton(
                    onPress: onSubmit,
                    labelText: "Go",
                    color: ColorManager.textColor,
                  ),
                ),
                const SizedBox(height: AppPadding.p32),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: AppPadding.p16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buttonWidget('7'),
                    buttonWidget('8'),
                    buttonWidget('9'),
                    tipsButtons(paymentDue! / 2),
                  ],
                ),
                const SizedBox(height: AppPadding.p16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buttonWidget('4'),
                    buttonWidget('5'),
                    buttonWidget('6'),
                    tipsButtons(paymentDue! + 10),
                  ],
                ),
                const SizedBox(height: AppPadding.p16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buttonWidget('1'),
                    buttonWidget('2'),
                    buttonWidget('3'),
                    tipsButtons(paymentDue! + 100),
                  ],
                ),
                const SizedBox(height: AppPadding.p16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    iconButtonWidget(Icons.backspace_outlined, () {
                      if (padTextController.text.isNotEmpty) {
                        padTextController.text = padTextController.text
                            .substring(0, padTextController.text.length - 1);
                      }
                      onChange(padTextController.text);
                    }),
                    buttonWidget('0'),
                    buttonWidget('.'),
                    tipsButtons(paymentDue!, isExact: true),
                  ],
                ),
              ],
            ),
    );
  }

  buttonWidget(String buttonText) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isPinLogin && padTextController.text.length == 4)
            return;
          else if (padTextController.text.contains('.') && buttonText == '.')
            return;
          padTextController.text = padTextController.text + buttonText;
          onChange(padTextController.text);
        },
        child: isPinLogin
            ? Container(
                height: 55,
                // width: 90,
                decoration: BoxDecoration(
                  color: ColorManager.coolGray.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(AppPadding.p8 / 2),
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: getLightStyle(
                        color: ColorManager.textHeaderColor,
                        fontSize: FontSize.s24),
                  ),
                ),
              )
            : Container(
                height: buttonSize,
                width: buttonSize,
                margin: getPadding(horizontal: AppPadding.p8),
                decoration: BoxDecoration(
                  color: ColorManager.textColor,
                  borderRadius: BorderRadius.circular(AppPadding.p24),
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: getLightStyle(
                        color: ColorManager.white, fontSize: FontSize.s32),
                  ),
                ),
              ),
      ),
    );
  }

  tipsButtons(double amount, {bool isExact = false}) {
    return GestureDetector(
      onTap: () {
        // if (padTextController.text.isNotEmpty) {
        //   padTextController.text = (double.parse(padTextController.text) + amount).toString();
        // } else {
        //   padTextController.text = (double.parse('0.00') + amount).toString();
        // }
        padTextController.text =
            (double.parse('0.00') + amount).toStringAsFixed(2);
        onChange(padTextController.text);
      },
      child: Container(
        padding: getPadding(horizontal: AppPadding.p8),
        height: buttonSize,
        width: buttonSize + 20,
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.circular(AppPadding.p24),
        ),
        child: FittedBox(
          child: Center(
            child: Text(
              isExact ? "Exact" : "\$${amount.toStringAsFixed(2)}",
              style: getLightStyle(
                  color: ColorManager.white, fontSize: FontSize.s18),
            ),
          ),
        ),
      ),
    );
  }

  iconButtonWidget(IconData icon, VoidCallback function) {
    return isPinLogin
        ? Expanded(
            child: InkWell(
              onTap: function,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppPadding.p24),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 30,
                    color: ColorManager.coolGray.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: InkWell(
              onTap: function,
              child: Container(
                margin: getPadding(horizontal: AppPadding.p8),
                height: buttonSize,
                width: buttonSize,
                decoration: BoxDecoration(
                  color: ColorManager.textSubTitleColor,
                  borderRadius: BorderRadius.circular(AppPadding.p24),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
  }
}

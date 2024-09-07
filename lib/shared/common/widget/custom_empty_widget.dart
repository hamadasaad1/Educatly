import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/styles_manager.dart';
import 'custom_image_widget.dart';

enum EmptyScreenTypes {
  emptyModify,
  emptyList,
  emptySearch,
  emptyScreen,
  genericError,
  emptyOrder,
  emptyCard,
  emptyNotification,
}

class CustomEmptyScreen extends StatelessWidget {
  final String title;
  final String? description;
  final String? iconName;
  final Widget? actionWidget;
  final bool? emphasizeSvg;
  final EmptyScreenTypes? emptyScreenTypes;

  const CustomEmptyScreen(
      {required this.title,
      this.description,
      this.iconName,
      this.actionWidget,
      this.emphasizeSvg,
      this.emptyScreenTypes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (emptyScreenTypes != null)
          CustomSvgImage(
              imageName: emptyScreenTypes == EmptyScreenTypes.emptyList
                  ? Assets.assetsSvgEmptyList
                  : emptyScreenTypes == EmptyScreenTypes.emptySearch
                      ? Assets.assetsSvgEmptySearch
                      : emptyScreenTypes == EmptyScreenTypes.emptyOrder
                          ? Assets.assetsSvgEmptyOrder
                          : emptyScreenTypes == EmptyScreenTypes.emptyScreen
                              ? Assets.assetsSvgEmptyScreen2
                              : emptyScreenTypes ==
                                      EmptyScreenTypes.genericError
                                  ? Assets.assetsSvgErrorGeneric
                                  : emptyScreenTypes ==
                                          EmptyScreenTypes.emptyNotification
                                      ? Assets.assetsSvgEmptyNotification
                                      : emptyScreenTypes ==
                                              EmptyScreenTypes.emptyCard
                                          ? Assets.assetsSvgErrorGeneric
                                          : Assets.assetsSvgEmptyScreen2)
        else
          emphasizeSvg == true
              ? Container(
                  margin: const EdgeInsets.all(AppPadding.p8),
                  padding: const EdgeInsets.all(AppPadding.p16),
                  child: SvgPicture.asset(
                    iconName ?? Assets.assetsSvgEmpty,
                    color: ColorManager.primary,
                  ),
                )
              : Container(
                  height: AppSize.s80,
                  width: AppSize.s80,
                  margin: const EdgeInsets.all(AppPadding.p8),
                  padding: const EdgeInsets.all(AppPadding.p16),
                  decoration: BoxDecoration(
                    // color: ColorManager.primary.withOpacity(.16),
                    color: ColorManager.lightPrimary,
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  ),
                  child: SvgPicture.asset(
                    iconName ?? Assets.assetsSvgEmpty,
                    color: ColorManager.primary,
                  ),
                ),
        Padding(
          padding: const EdgeInsets.only(top: AppPadding.p8),
          child: Text(
            // emptyScreenTypes == EmptyScreenTypes.emptyList ? "Empty List" : title,
            title,
            style: getBoldStyle(
                color: ColorManager.primary, fontSize: FontSize.s20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: AppPadding.p8 / 2, bottom: AppPadding.p28),
          child: Text(
            // emptyScreenTypes == EmptyScreenTypes.emptyList ? 'This list is currently empty, Check again later' : description ?? '',
            description ?? '',
            textAlign: TextAlign.center,
            style: getRegularStyle(fontSize: FontSize.s14),
          ),
        ),
        actionWidget ?? SizedBox(),
      ],
    );
  }
}

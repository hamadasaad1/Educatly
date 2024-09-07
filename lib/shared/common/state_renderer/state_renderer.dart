import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/size_config.dart';
import '../../resources/strings_manager.dart';
import '../../resources/styles_manager.dart';
import '../widget/component.dart';

enum StateRendererType {
//popup dialog
  popupLoadingState,
  popupErrorState,

//full screen
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

//general
  contentState,
  initialState
}

class StateRenderer extends StatelessWidget {
  final StateRendererType stateRendererType;
  final String message;
  final String title;
  final Function retryActionFunction;

  StateRenderer(
      {Key? key,
      required this.retryActionFunction,
      this.message = AppStrings.loading,
      this.title = '',
      required this.stateRendererType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getStateContent(context);
  }

  Widget _getStateContent(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(
          context,
          [
            _getAnimatedImage(Assets.assetsJsonLoadingNew),
          ],
        );
      case StateRendererType.popupErrorState:
        return Padding(
          padding: getPadding(horizontal: AppPadding.p24, isContent: false),
          child: _getErrorPopupDialog(context, [
            _getAnimatedImage(Assets.assetsJsonError),
            _getMessage(message),
            Row(
              children: [
                // Expanded(child: _getRetryButton(AppStrings.reTryAgain, context)),
                Expanded(child: _getRetryButton(AppStrings.ok, context)),
              ],
            )
          ]),
        );
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn([
          _getAnimatedImage(Assets.assetsJsonLoadingNew),
          _getMessage(message),
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(Assets.assetsJsonError),
          _getMessage(message),
          _getRetryButton(AppStrings.reTryAgain, context)
        ]);

      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn([
          _getAnimatedImage(Assets.assetsJsonEmpty),
          _getMessage(message),
        ]);
      case StateRendererType.contentState:
        return Container();

      default:
        return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        // decoration: BoxDecoration(
        //   color: ColorManager.white,
        //   shape: BoxShape.rectangle,
        //   borderRadius: BorderRadius.circular(AppSize.s12),
        //   boxShadow: const [BoxShadow(color: Colors.black38)],
        // ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getErrorPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Container(
        margin: getMargin(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p16,
            isContent: false),
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s12),
          // boxShadow: const [BoxShadow(color: Colors.black38)],
        ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String pathName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(pathName),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: getRegularStyle(
              color: ColorManager.black, fontSize: FontSize.s18),
        ),
      ),
    );
  }

  Widget _getRetryButton(String title, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (stateRendererType ==
                      StateRendererType.fullScreenErrorState) {
                    if (message.contains('Unauthorized')) {
                      //   instance<AppPreferences>().clearDataToSharedPref();
                      Phoenix.rebirth(context);
                    } else {
                      // call retry Function
                      Navigator.of(context).pop();
                      retryActionFunction.call();
                    }
                  } else {
                    dismissDialog(context);
                    //popup error State
                    Navigator.of(context).pop();
                  }
                },
                child: Text(title))),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../resources/strings_manager.dart';
import 'state_renderer.dart';

abstract class StateFlow {
  StateRendererType getStateRenderer();

  String getMessage();
}

//loading state

class LoadingState extends StateFlow {
  StateRendererType stateRendererType;
  String? message;

  LoadingState(
      {required this.stateRendererType, this.message = AppStrings.loading});

  @override
  String getMessage() {
    return message ?? AppStrings.loading;
  }

  @override
  StateRendererType getStateRenderer() {
    return stateRendererType;
  }
}

//error State

class ErrorState extends StateFlow {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendererType getStateRenderer() {
    return stateRendererType;
  }
}

//content state
class ContentState extends StateFlow {
  StateRendererType? stateRendererType;

  ContentState({
    this.stateRendererType = StateRendererType.initialState,
  });

  @override
  String getMessage() {
    return Constants.empty;
  }

  @override
  StateRendererType getStateRenderer() {
    return stateRendererType!;
  }
}

// empty state
class EmptyState extends StateFlow {
  String message;

  EmptyState({
    required this.message,
  });

  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendererType getStateRenderer() {
    return StateRendererType.fullScreenEmptyState;
  }
}

extension FlowStateExtension on StateFlow {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function reTryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRenderer() == StateRendererType.popupLoadingState) {
            //show loading popup
            showPopupDialog(context, getStateRenderer(), getMessage());

            //show content
            return contentScreenWidget;
          } else {
            //full state loading screen

            return StateRenderer(
              message: getMessage(),
              stateRendererType: getStateRenderer(),
              retryActionFunction: reTryActionFunction,
            );
          }
        }

      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRenderer() == StateRendererType.popupErrorState) {
            showPopupDialog(context, getStateRenderer(), getMessage());

//show content
            return contentScreenWidget;
          } else {
            return StateRenderer(
              retryActionFunction: reTryActionFunction,
              stateRendererType: getStateRenderer(),
              message: getMessage(),
            );
          }
        }
      case EmptyState:
        {
          return StateRenderer(
            retryActionFunction: () {},
            stateRendererType: getStateRenderer(),
            message: getMessage(),
          );
        }
      case ContentState:
        {
          log(getStateRenderer().toString());
          if (getStateRenderer() == StateRendererType.contentState) {
            dismissDialog(context);
          }

          return contentScreenWidget;
        }

      default:
        if (getStateRenderer() == StateRendererType.contentState) {
          dismissDialog(context);
        }
        return contentScreenWidget;
    }
  }

//this function to check have dialog or not

  _isCurrentDialogShow(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShow(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopupDialog(BuildContext context, StateRendererType stateRendererType,
      String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        barrierColor: Colors.grey.withOpacity(.3),
        builder: (BuildContext context) => StateRenderer(
            retryActionFunction: () {},
            message: message,
            stateRendererType: stateRendererType)));
  }
}

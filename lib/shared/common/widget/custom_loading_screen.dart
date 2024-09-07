import 'package:flutter/material.dart';

import '../state_renderer/state_renderer.dart';

class CustomLoadingScreen extends StatelessWidget {
  final StateRendererType? stateRendererType;
  final Function? retryActionFunction;
  final String? message;

  const CustomLoadingScreen({
    Key? key,
    this.stateRendererType,
    this.retryActionFunction,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateRenderer(
        retryActionFunction: retryActionFunction ?? () {},
        message: message ?? '',
        stateRendererType:
            stateRendererType ?? StateRendererType.popupLoadingState);
  }
}

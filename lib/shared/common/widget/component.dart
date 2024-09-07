import 'dart:async';

import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/styles_manager.dart';
import '../state_renderer/state_renderer.dart';

Future<dynamic> changeNavigator(context, widget,
    {bool isFullDialog = false}) async {
  var response = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => widget, fullscreenDialog: isFullDialog),
  );
  return response;
}

Future<dynamic> changeNavigatorAndRemoveUntil(context, widget) async {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false,
  );
}

showLoadingDialog(BuildContext _context,
    {bool showMessage = false, Color? color}) {
  Future.delayed(Duration(milliseconds: 100), () {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool showCloseButton = false;
        return StatefulBuilder(builder: (_context, mytState) {
          Timer(Duration(seconds: 10), () {
            if (!showCloseButton) {
              mytState(() {
                showCloseButton = true;
                print(showCloseButton);
              });
            }
          });

          return SizedBox(
            width: double.infinity,
            child: Scaffold(
              backgroundColor: color ?? Colors.black.withOpacity(0.4),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showCloseButton) ...[
                    const SizedBox(
                      height: 40,
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            hideLoadingDialog(_context, () {});
                            //dismissDialog(_context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: SizedBox.expand(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(child: CircularProgressIndicator()),
                          if (showCloseButton) ...[
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                  'It seems it takes much longer than expected.',
                                  textAlign: TextAlign.center,
                                  style: getRegularStyle(
                                      color: ColorManager.white)),
                            ),
                          ],
                          if (showMessage)
                            Padding(
                              padding:
                                  const EdgeInsets.all(18.0).copyWith(top: 40),
                              child: Center(
                                child: Text(
                                    'Continue using payment terminal to complete this transaction',
                                    textAlign: TextAlign.center,
                                    style: getRegularStyle(
                                        color: ColorManager.white)),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).then((value) => null);
  });
}

hideLoadingDialog(BuildContext context, Function function) {
  Future.delayed(Duration(milliseconds: 100), () {
    Navigator.pop(context);
  });

  function();
}

_isCurrentDialogShow(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

dismissDialog(BuildContext context) {
  if (_isCurrentDialogShow(context)) {
    Navigator.of(context, rootNavigator: true).pop(true);
  }
}

showPopupDialog(
    {required BuildContext context,
    required StateRendererType stateRendererType,
    Function? retryActionFunction,
    String? message}) {
  WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
      context: context,
      barrierColor: Colors.grey.withOpacity(.3),
      builder: (BuildContext context) => StateRenderer(
          retryActionFunction: retryActionFunction ?? () {},
          message: message ?? '',
          stateRendererType: stateRendererType)));
}

void showSnackBar(BuildContext context, String? message) {
  final snackBar = SnackBar(
    content: Text(message ?? ""),
    backgroundColor: ColorManager.primary,
    action: SnackBarAction(
      textColor: Colors.black,
      label: 'Done',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

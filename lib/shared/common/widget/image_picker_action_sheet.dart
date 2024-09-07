import 'package:flutter/cupertino.dart';

import '../../../app/media/media_service_interface.dart';
import '../../resources/styles_manager.dart';

class ImagePickerActionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            'Camera',
            style: getRegularStyle(),
          ),
          onPressed: () => Navigator.of(context).pop(AppImageSource.camera),
        ),
        CupertinoActionSheetAction(
          child: Text(
            'Gallery',
            style: getRegularStyle(),
          ),
          onPressed: () => Navigator.of(context).pop(AppImageSource.gallery),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
          style: getRegularStyle(),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

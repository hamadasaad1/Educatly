import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../permission/permission_service.dart';
import '../service_locator.dart';
import 'media_service_interface.dart';

class MediaService implements MediaServiceInterface {
  @override
  PermissionService get permissionService => locator<PermissionService>();

  Future<bool> _handleImageUploadPermissions(
      BuildContext context, AppImageSource? _imageSource) async {
    if (_imageSource == null) {
      return false;
    }
    if (_imageSource == AppImageSource.camera) {
      return await permissionService.handleCameraPermission(context);
    } else if (_imageSource == AppImageSource.gallery) {
      return await permissionService.handlePhotosPermission(context);
    } else {
      return false;
    }
  }

  @override
  Future<File?> uploadImage(
    BuildContext context,
    AppImageSource appImageSource, {
    bool shouldCompress = true,
  }) async {
    // Handle permissions according to image source,
    bool canProceed =
        await _handleImageUploadPermissions(context, appImageSource);

    if (canProceed) {
      File? processedPickedImageFile;

      // Convert our own AppImageSource into a format readable by the used package
      // In this case it's an ImageSource enum
      ImageSource? _imageSource =
          ImageSource.values.byName(appImageSource.name);

      final imagePicker = ImagePicker();
      final rawPickedImageFile =
          await imagePicker.pickImage(source: _imageSource, imageQuality: 50);

      if (rawPickedImageFile != null) {
        //to convert from XFile type provided by the package to dart:io's File type
        processedPickedImageFile = File(rawPickedImageFile.path);
        // if (shouldCompress) {
        //   processedPickedImageFile = await compressFile(processedPickedImageFile);
        // }
      }
      return processedPickedImageFile;
    }
  }

  @override
  Future<File?> compressFile(File file, {int quality = 30}) {
    // TODO: implement compressFile
    throw UnimplementedError();
  }

// @override
// Future<File?> compressFile(File file, {int quality = 30}) async {
//   final dir = await path_provider.getTemporaryDirectory();
//   final targetPath = dir.absolute.path + '/${Random().nextInt(1000)}-temp.jpg';

//   return await FlutterImageCompress.compressAndGetFile(
//     file.absolute.path,
//     targetPath,
//     quality: quality,
//   );
// }
}

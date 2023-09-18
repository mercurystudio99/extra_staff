import 'dart:math';
import 'dart:typed_data';
import 'package:extra_staff/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class SavePhotoController extends GetxController {
  bool? safetyBoots;
  XFile? image;
  MediaInfo? imageInfoforWeb;

  Future<String> profileUploadUrl() async {
    if (isWebApp) {
      if (imageInfoforWeb == null) {
        return 'selectImage'.tr;
      }
      String? imagePath = imageInfoforWeb!.fileName;
      var message = '';
      final str = generateRandomString(32) + '.' + imagePath!.split('.').last;
      final getUrl = await Services.shared.profileUploadUrl(str);
      message = getUrl.message;
      final uploadImage = await Services.shared
          .putImageBytes(getUrl.data['url'], imagePath, imageInfoforWeb!.data!);
      message = uploadImage;
      final photoInfo = await Services.shared.updateTempPhotoInfo(str);
      message = photoInfo.errorMessage;
      return message;
    } else {
      if (image == null) {
        return 'selectImage'.tr;
      }
      var message = '';
      final str = generateRandomString(32) + '.' + image!.path.split('.').last;
      final getUrl = await Services.shared.profileUploadUrl(str);
      message = getUrl.message;
      final uploadImage =
          await Services.shared.putImage(getUrl.data['url'], image!);
      message = uploadImage;
      final photoInfo = await Services.shared.updateTempPhotoInfo(str);
      message = photoInfo.errorMessage;
      return message;
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}

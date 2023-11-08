import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';

@immutable
class UploadAndGetImageToFireStoreUseCase {
  final FireBaseService fireBaseService;

  const UploadAndGetImageToFireStoreUseCase(this.fireBaseService);

  Future<String> call(File imageFile, String productName) async =>
      await fireBaseService.uploadImage(imageFile, productName);
}

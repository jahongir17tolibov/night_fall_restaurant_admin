import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';

@immutable
class DeleteMenuProductFromFireStoreUseCase {
  final FireBaseService fireBaseService;

  const DeleteMenuProductFromFireStoreUseCase(this.fireBaseService);

  Future<void> call(String productName) async =>
      fireBaseService.deleteMenuProduct(productName);
}

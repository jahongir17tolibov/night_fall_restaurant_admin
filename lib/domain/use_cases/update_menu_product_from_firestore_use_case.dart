import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/editing_menu_product_model.dart';

@immutable
class UpdateMenuProductFromFireStoreUseCase {
  final FireBaseService fireBaseService;

  const UpdateMenuProductFromFireStoreUseCase(this.fireBaseService);

  Future<void> call(EditingMenuProductsModel product) async =>
      await fireBaseService.updateProduct(product);
}

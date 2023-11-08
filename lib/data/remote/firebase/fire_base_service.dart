import 'dart:io';

import 'package:night_fall_restaurant_admin/data/remote/model/menu_products/get_menu_list_response.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/orders/get_orders_list_response.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/editing_menu_product_model.dart';

abstract class FireBaseService {
  Future<GetMenuListResponse> getMenuList();

  Future<List<GetOrdersListResponse>> getOrdersList();

  Future<String> uploadImage(File imageFile, String productName);

  Future<void> addNewProduct(EditingMenuProductsModel product);

  Future<void> updateProduct(EditingMenuProductsModel product);

  Future<void> deleteMenuProduct(String productName);
}

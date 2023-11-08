import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/data/local/db/dao/menu_products_dao.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';

@immutable
class GetSingleProductUseCase {
  final MenuProductsDao dao;

  const GetSingleProductUseCase(this.dao);

  Future<MenuProductsEntity> call(int productId) async =>
      dao.getSingleMenuProduct(productId);
}

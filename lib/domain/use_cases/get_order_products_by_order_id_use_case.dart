import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/order_products_entity.dart';
import 'package:night_fall_restaurant_admin/domain/repository/main_repo/repository.dart';

@immutable
class GetProductsByOrderIdUseCase {
  final Repository repository;

  const GetProductsByOrderIdUseCase(this.repository);

  Future<Result<List<OrderProductsEntity>>> call(String orderUniqueId) async =>
      await repository.getOrderProductsFromDb(orderUniqueId);
}

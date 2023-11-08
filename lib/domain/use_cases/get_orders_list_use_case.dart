import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/orders_list_entity.dart';
import 'package:night_fall_restaurant_admin/domain/repository/main_repo/repository.dart';

@immutable
class GetOrdersListUseCase {
  final Repository repository;

  const GetOrdersListUseCase(this.repository);

  Future<Result<List<OrdersListEntity>>> call() async =>
      await repository.getOrdersListFromDb();
}

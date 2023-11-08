import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/data/local/db/dao/orders_dao.dart';

@immutable
class ClearAllOrdersUseCase {
  final OrdersDao dao;

  const ClearAllOrdersUseCase(this.dao);

  Future<void> call() async => await dao.clearAllOrdersList();
}

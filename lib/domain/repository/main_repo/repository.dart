import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/order_products_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/orders_list_entity.dart';

abstract class Repository {
  Future<void> syncOrdersList();

  Future<Result<List<OrdersListEntity>>> getOrdersListFromDb();

  Future<Result<List<OrderProductsEntity>>> getOrderProductsFromDb(
      String orderId);
}

import 'package:night_fall_restaurant_admin/data/local/entities/order_products_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/orders_list_entity.dart';
import 'package:sqflite/sqflite.dart';

class OrdersDao {
  final Database database;

  OrdersDao(this.database);

  Future<void> insertOrdersList(OrdersListEntity ordersListDto) async {
    try {
      await database.insert(
        OrdersListEntity.TABLE_NAME,
        ordersListDto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> insertOrderProducts(
      OrderProductsEntity orderProductsEntity) async {
    try {
      await database.insert(
        OrderProductsEntity.TABLE_NAME,
        orderProductsEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }

  // Future<void> toggleUpdateIsChecked(int isChecked, int id) async {
  //   const String sqlQuery =
  //       "UPDATE $ordersListTableName SET isChecked = ? WHERE id = ?";
  //   try {
  //     await database.rawUpdate(sqlQuery, [isChecked, id]);
  //   } catch (_) {
  //     rethrow;
  //   }
  // }

  Future<List<OrdersListEntity>> getCachedOrdersList() async {
    try {
      String sqlQuery = """
    SELECT * FROM ${OrdersListEntity.TABLE_NAME} ORDER BY ${OrdersListEntity.CM_SEND_TIME} ASC
    """;
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      return query.map((e) => OrdersListEntity.fromMap(e)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<List<OrderProductsEntity>> getCachedOrderProducts() async {
    try {
      String sqlQuery = """
    SELECT * FROM ${OrderProductsEntity.TABLE_NAME} ORDER BY ${OrderProductsEntity.CM_ID} ASC
    """;
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      return query.map((e) => OrderProductsEntity.fromMap(e)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<List<OrderProductsEntity>> getProductsByOrderId(
    String orderId,
  ) async {
    try {
      String sqlQuery = """
    SELECT * FROM ${OrderProductsEntity.TABLE_NAME} WHERE ${OrderProductsEntity.CM_ORDER_UNIQUE_ID} = '$orderId'
    """;
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      if (query.isNotEmpty) {
        return query.map((e) => OrderProductsEntity.fromMap(e)).toList();
      } else {
        throw Exception('Order products is Empty');
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> clearAllOrdersList() async {
    String sqlQuery = """
    DELETE FROM ${OrdersListEntity.TABLE_NAME}
    """;
    try {
      await database.rawDelete(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> clearAllOrderProducts() async {
    String sqlQuery = """
    DELETE FROM ${OrderProductsEntity.TABLE_NAME}
    """;
    try {
      await database.rawDelete(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }
}

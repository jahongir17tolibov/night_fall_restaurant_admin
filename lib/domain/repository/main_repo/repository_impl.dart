import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/db/dao/orders_dao.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/order_products_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/orders_list_entity.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';
import 'package:night_fall_restaurant_admin/domain/repository/main_repo/repository.dart';

class RepositoryImpl extends Repository {
  final FireBaseService fireBaseService;
  final OrdersDao dao;

  RepositoryImpl({required this.fireBaseService, required this.dao});

  static final Exception _ifEmptyDataException = Exception(
    "The database is empty or check your Internet connection.",
  );

  @override
  Future<void> syncOrdersList() async {
    final ordersListFromDb = await dao.getCachedOrdersList();
    final orderProductsFromDb = await dao.getCachedOrderProducts();
    final ordersListFromFireStore = await fireBaseService.getOrdersList();
    try {
      final mappingOrderList = ordersListFromFireStore
          .map((data) => OrdersListEntity.fromGetOrdersListResponse(data))
        ..forEach((orders) async {
          if (ordersListFromDb.isEmpty) {
            await dao.insertOrdersList(orders);
          }
        });

      final mappingOrderProducts = ordersListFromFireStore.expand(
        (data) => data.orderProducts.map(
          (products) => OrderProductsEntity.fromOrderProducts(products),
        ),
      )..forEach((products) async {
          if (orderProductsFromDb.isEmpty) {
            await dao.insertOrderProducts(products);
          }
        });

      if (ordersListFromDb.isNotEmpty && orderProductsFromDb.isNotEmpty) {
        if (ordersListFromDb.length != ordersListFromFireStore.length) {
          await _operationOrdersList(mappingOrderList);
          await _operationOrderProducts(mappingOrderProducts);
        }
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Result<List<OrdersListEntity>>> getOrdersListFromDb() async {
    try {
      final ordersList = await dao.getCachedOrdersList();
      if (ordersList.isNotEmpty) {
        return SUCCESS(data: ordersList);
      } else {
        return FAILURE(exception: _ifEmptyDataException);
      }
    } on Exception catch (e) {
      return FAILURE(exception: e);
    }
  }

  @override
  Future<Result<List<OrderProductsEntity>>> getOrderProductsFromDb(
    String orderId,
  ) async {
    try {
      final orderProducts = await dao.getProductsByOrderId(orderId);
      if (orderProducts.isNotEmpty) {
        return SUCCESS(data: orderProducts);
      } else {
        return FAILURE(exception: _ifEmptyDataException);
      }
    } on Exception catch (e) {
      return FAILURE(exception: e);
    }
  }

  Future<void> _operationOrdersList(
    Iterable<OrdersListEntity> mappingOrderList,
  ) async {
    await dao.clearAllOrdersList();
    for (var orders in mappingOrderList) {
      await dao.insertOrdersList(orders);
    }
  }

  Future<void> _operationOrderProducts(
    Iterable<OrderProductsEntity> mappingOrderProducts,
  ) async {
    await dao.clearAllOrderProducts();
    for (var products in mappingOrderProducts) {
      await dao.insertOrderProducts(products);
    }
  }
}

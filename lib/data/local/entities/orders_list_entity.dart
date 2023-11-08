// ignore_for_file: constant_identifier_names

import 'package:night_fall_restaurant_admin/data/remote/model/orders/get_orders_list_response.dart';

class OrdersListEntity {
  static const String CM_ID = "id";
  static const String CM_ORDER_ID = "order_id";
  static const String CM_TABLE_NUMBER = "table_number";
  static const String CM_SEND_TIME = "send_time";
  static const String CM_TOTAL_PRICE = "total_price";
  static const String TABLE_NAME = "orders_list_entity";

  int? id;
  final String orderId;
  final String tableNumber;
  final String sendTime;
  final String totalPrice;

  OrdersListEntity({
    this.id,
    required this.orderId,
    required this.tableNumber,
    required this.sendTime,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        CM_ID: id,
        CM_ORDER_ID: orderId,
        CM_TABLE_NUMBER: tableNumber,
        CM_SEND_TIME: sendTime,
        CM_TOTAL_PRICE: totalPrice,
      };

  factory OrdersListEntity.fromMap(Map<String, dynamic> map) =>
      OrdersListEntity(
        id: map[CM_ID],
        orderId: map[CM_ORDER_ID],
        tableNumber: map[CM_TABLE_NUMBER],
        sendTime: map[CM_SEND_TIME],
        totalPrice: map[CM_TOTAL_PRICE],
      );

  factory OrdersListEntity.fromGetOrdersListResponse(
    GetOrdersListResponse getOrdersListResponse,
  ) {
    return OrdersListEntity(
      orderId: getOrdersListResponse.orderId,
      tableNumber: getOrdersListResponse.tableNumber,
      sendTime: getOrdersListResponse.sendTime,
      totalPrice: getOrdersListResponse.totalPrice,
    );
  }

  OrdersListEntity copyWith({
    int? id,
    String? orderId,
    String? tableNumber,
    String? sendTime,
    String? totalPrice,
  }) =>
      OrdersListEntity(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        tableNumber: tableNumber ?? this.tableNumber,
        sendTime: sendTime ?? this.sendTime,
        totalPrice: totalPrice ?? this.totalPrice,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersListEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          orderId == other.orderId &&
          tableNumber == other.tableNumber &&
          sendTime == other.sendTime &&
          totalPrice == other.totalPrice;

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      tableNumber.hashCode ^
      sendTime.hashCode ^
      totalPrice.hashCode;
}

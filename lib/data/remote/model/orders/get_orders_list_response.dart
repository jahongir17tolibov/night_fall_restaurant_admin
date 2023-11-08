import 'package:night_fall_restaurant_admin/data/remote/model/orders/order_products.dart';

class GetOrdersListResponse {
  final String orderId;
  final String tableNumber;
  final String sendTime;
  final String totalPrice;
  final List<OrderProducts> orderProducts;

  GetOrdersListResponse({
    required this.orderId,
    required this.tableNumber,
    required this.sendTime,
    required this.totalPrice,
    required this.orderProducts,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'orderId': orderId,
        'tableNumber': tableNumber,
        'sendTime': sendTime,
        'totalPrice': totalPrice,
        'orderProducts':
            orderProducts.map((product) => product.toMap()).toList(),
      };

  factory GetOrdersListResponse.fromMap(Map<String, dynamic> map) {
    List<dynamic> orderProductsData = map['orderProducts'];

    List<OrderProducts> orderProducts = orderProductsData
        .map((products) => OrderProducts.fromMap(products))
        .toList();

    return GetOrdersListResponse(
      orderId: map['orderId'],
      tableNumber: map['tableNumber'],
      sendTime: map['sendTime'],
      totalPrice: map['totalPrice'],
      orderProducts: orderProducts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetOrdersListResponse &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          tableNumber == other.tableNumber &&
          sendTime == other.sendTime &&
          totalPrice == other.totalPrice &&
          orderProducts == other.orderProducts;

  @override
  int get hashCode =>
      orderId.hashCode ^
      tableNumber.hashCode ^
      sendTime.hashCode ^
      totalPrice.hashCode ^
      orderProducts.hashCode;
}

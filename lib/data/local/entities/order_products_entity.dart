// ignore_for_file: constant_identifier_names

import 'package:night_fall_restaurant_admin/data/remote/model/orders/order_products.dart';

class OrderProductsEntity {
  static const String CM_ID = "id";
  static const String CM_ORDER_UNIQUE_ID = "from_order_uniqueId";
  static const String CM_ORDER_PRODUCT_FIRE_ID = "fire_id";
  static const String CM_PRODUCT_NAME = "product_name";
  static const String CM_PRICE = "image";
  static const String CM_IMAGE = "price";
  static const String CM_WEIGHT = "weight";
  static const String CM_AMOUNT = "amount";
  static const String TABLE_NAME = "order_products_entity";

  int? id;
  final String fireId;
  final String fromOrderUniqueId;
  final String productName;
  final String image;
  final String price;
  final String weight;
  final String amount;

  OrderProductsEntity({
    this.id,
    required this.fireId,
    required this.fromOrderUniqueId,
    required this.productName,
    required this.price,
    required this.weight,
    required this.image,
    required this.amount,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        CM_ID: id,
        CM_ORDER_PRODUCT_FIRE_ID: fireId,
        CM_ORDER_UNIQUE_ID: fromOrderUniqueId,
        CM_PRODUCT_NAME: productName,
        CM_IMAGE: image,
        CM_PRICE: price,
        CM_WEIGHT: weight,
        CM_AMOUNT: amount,
      };

  factory OrderProductsEntity.fromMap(Map<String, dynamic> map) =>
      OrderProductsEntity(
        id: map[CM_ID],
        fireId: map[CM_ORDER_PRODUCT_FIRE_ID],
        fromOrderUniqueId: map[CM_ORDER_UNIQUE_ID],
        productName: map[CM_PRODUCT_NAME],
        image: map[CM_IMAGE],
        price: map[CM_PRICE],
        weight: map[CM_WEIGHT],
        amount: map[CM_AMOUNT],
      );

  factory OrderProductsEntity.fromOrderProducts(
    OrderProducts orderProducts,
  ) =>
      OrderProductsEntity(
        fireId: orderProducts.fireId,
        fromOrderUniqueId: orderProducts.orderId,
        productName: orderProducts.productName,
        price: orderProducts.price,
        weight: orderProducts.weight,
        image: orderProducts.image,
        amount: orderProducts.amount,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderProductsEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fromOrderUniqueId == other.fromOrderUniqueId &&
          fireId == other.fireId &&
          productName == other.productName &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          amount == other.amount;

  @override
  int get hashCode =>
      id.hashCode ^
      fromOrderUniqueId.hashCode ^
      fireId.hashCode ^
      productName.hashCode ^
      weight.hashCode ^
      image.hashCode ^
      price.hashCode ^
      amount.hashCode;
}

class OrderProducts {
  final String orderId;
  final String productName;
  final String price;
  final String weight;
  final String image;
  final String amount;

  OrderProducts({
    required this.orderId,
    required this.productName,
    required this.price,
    required this.weight,
    required this.image,
    required this.amount,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'orderProductId': orderId,
        'productName': productName,
        'image': image,
        'price': price,
        'weight': weight,
        'amount': amount,
      };

  factory OrderProducts.fromMap(Map<String, dynamic> map) => OrderProducts(
        orderId: map['orderId'],
        productName: map['productName'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        amount: map['amount'],
      );

  // factory OrderProducts.fromOrdersEntity(OrdersEntity ordersEntity) =>
  //     OrderProducts(
  //       orderProductId: ordersEntity.orderProductId,
  //       productName: ordersEntity.name,
  //       price: ordersEntity.price,
  //       weight: ordersEntity.weight,
  //       image: ordersEntity.image,
  //       amount: ordersEntity.quantity.toString(),
  //     );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderProducts &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          productName == other.productName &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          amount == other.amount;

  @override
  int get hashCode =>
      orderId.hashCode ^
      productName.hashCode ^
      weight.hashCode ^
      image.hashCode ^
      price.hashCode ^
      amount.hashCode;
}

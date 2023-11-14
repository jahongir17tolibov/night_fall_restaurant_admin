import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';

class EditingMenuProductsModel {
  final String fireId;
  final String name;
  final String image;
  final String price;
  final String weight;
  final String productCategoryId;

  EditingMenuProductsModel({
    required this.fireId,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    required this.productCategoryId,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fireId': fireId,
        'name': name,
        'image': image,
        'price': price,
        'weight': weight,
        'product_category_id': productCategoryId,
      };

  factory EditingMenuProductsModel.fromMap(Map<String, dynamic> map) =>
      EditingMenuProductsModel(
        fireId: map['fireId'],
        name: map['name'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        productCategoryId: map['product_category_id'],
      );

  factory EditingMenuProductsModel.fromMenuProductsEntity({
    required MenuProductsEntity menuProductsEntity,
  }) =>
      EditingMenuProductsModel(
        fireId: menuProductsEntity.fireId.toString(),
        name: menuProductsEntity.name,
        image: menuProductsEntity.image,
        price: menuProductsEntity.price,
        weight: menuProductsEntity.weight,
        productCategoryId: menuProductsEntity.productCategoryId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditingMenuProductsModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          productCategoryId == other.productCategoryId;

  @override
  int get hashCode =>
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      productCategoryId.hashCode;
}

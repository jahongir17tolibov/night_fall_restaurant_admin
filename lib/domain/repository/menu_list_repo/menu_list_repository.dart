import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';

abstract class MenuListRepository {
  Future<void> syncMenuProductsList();

  Future<Result<List<MenuProductsEntity>>> getMenuProductsFromDb();

  Future<List<MenuCategoriesEntity>> getMenuCategoriesFromDb();
}

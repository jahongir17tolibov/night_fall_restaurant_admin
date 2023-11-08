import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/db/dao/menu_products_dao.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';
import 'package:night_fall_restaurant_admin/domain/repository/menu_list_repo/menu_list_repository.dart';

class MenuListRepositoryImpl extends MenuListRepository {
  final FireBaseService fireBaseService;
  final MenuProductsDao dao;

  MenuListRepositoryImpl({required this.fireBaseService, required this.dao});

  static final Exception _ifEmptyDataException = Exception(
    "Database is empty or check internet connection",
  );

  @override
  Future<void> syncMenuProductsList() async {
    final menuProductsFromFireStore = await fireBaseService.getMenuList();
    final cachedMenuProductsList = await dao.getCachedMenuList();
    final cachedMenuCategories = await dao.getCachedMenuCategories();

    /// mapping fireStoreData to Database table
    try {
      final mappingMenuProductsList = menuProductsFromFireStore.menu_products
          .map((data) => MenuProductsEntity.fromMenuProductsListResponse(
                menuList: data,
              ))
        ..forEach((products) async {
          if (cachedMenuProductsList.isEmpty) {
            await dao.insertMenuProductsList(products);
          } else {
            await dao.updateMenuProductsList(products);
          }
        });

      final mappingMenuCategories = menuProductsFromFireStore.menu_categories
          .map((category) => MenuCategoriesEntity.fromMenuProductsListResponse(
                categories: category,
              ))
        ..forEach((categories) async {
          if (cachedMenuCategories.isEmpty) {
            await dao.insertMenuCategories(categories);
          } else {
            await dao.updateMenuCategoriesList(categories);
          }
        });

      if (cachedMenuProductsList.isNotEmpty &&
          cachedMenuCategories.isNotEmpty) {
        if (cachedMenuProductsList.length !=
            menuProductsFromFireStore.menu_products.length) {
          await _operationMenuProducts(mappingMenuProductsList);
          await _operationMenuCategories(mappingMenuCategories);
        }
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Result<List<MenuProductsEntity>>> getMenuProductsFromDb() async {
    try {
      final cachedMenuProducts = await dao.getCachedMenuList();
      if (cachedMenuProducts.isNotEmpty) {
        return SUCCESS(data: cachedMenuProducts);
      } else {
        return FAILURE(exception: _ifEmptyDataException);
      }
    } on Exception catch (e) {
      return FAILURE(exception: e);
    }
  }

  @override
  Future<List<MenuCategoriesEntity>> getMenuCategoriesFromDb() async {
    try {
      final cachedCategories = await dao.getCachedMenuCategories();
      if (cachedCategories.isNotEmpty) {
        return cachedCategories;
      } else {
        throw Exception('categories List is empty');
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _operationMenuProducts(
    Iterable<MenuProductsEntity> mappingMenuProductsList,
  ) async {
    await dao.clearMenuProducts();
    for (var products in mappingMenuProductsList) {
      await dao.insertMenuProductsList(products);
    }
  }

  Future<void> _operationMenuCategories(
    Iterable<MenuCategoriesEntity> mappingMenuCategories,
  ) async {
    await dao.clearMenuCategories();
    for (var categories in mappingMenuCategories) {
      await dao.insertMenuCategories(categories);
    }
  }
}

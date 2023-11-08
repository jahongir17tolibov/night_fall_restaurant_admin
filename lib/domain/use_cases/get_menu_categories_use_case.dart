import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant_admin/domain/repository/menu_list_repo/menu_list_repository.dart';

@immutable
class GetMenuCategoriesUseCase {
  final MenuListRepository repository;

  const GetMenuCategoriesUseCase(this.repository);

  Future<List<MenuCategoriesEntity>> call() async =>
      await repository.getMenuCategoriesFromDb();
}

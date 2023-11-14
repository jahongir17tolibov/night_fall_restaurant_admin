import 'package:get_it/get_it.dart';
import 'package:night_fall_restaurant_admin/data/local/db/dao/menu_products_dao.dart';
import 'package:night_fall_restaurant_admin/data/local/db/database/app_database.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service_impl.dart';
import 'package:night_fall_restaurant_admin/domain/repository/main_repo/repository.dart';
import 'package:night_fall_restaurant_admin/domain/repository/menu_list_repo/menu_list_repository.dart';
import 'package:night_fall_restaurant_admin/domain/repository/menu_list_repo/menu_list_repository_impl.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/add_new_product_to_fire_store_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/clear_all_orders_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/delete_menu_product_from_firestore_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_order_products_by_order_id_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_orders_list_from_fire_store_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_orders_list_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_single_product_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/sync_orders_list_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/update_menu_product_from_firestore_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/upload_and_get_image_to_fire_store_use_case.dart';
import 'package:night_fall_restaurant_admin/feature/add_new_product/bloc/add_new_product_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/editing_product/bloc/editing_product_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/products/bloc/products_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'data/local/db/dao/orders_dao.dart';
import 'domain/repository/main_repo/repository_impl.dart';
import 'feature/home/bloc/home_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  /// blocs
  getIt.registerFactory<HomeBloc>(() => HomeBloc(
        syncOrdersListUseCase: getIt<SyncOrdersListUseCase>(),
        getOrdersListUseCase: getIt<GetOrdersListUseCase>(),
        getProductsByOrderIdUseCase: getIt<GetProductsByOrderIdUseCase>(),
        clearAllOrdersUseCase: getIt<ClearAllOrdersUseCase>(),
        fireStoreUseCase: getIt<GetOrdersListFromFireStoreUseCase>(),
      ));

  getIt.registerFactory<ProductsBloc>(() => ProductsBloc(
        repository: getIt<MenuListRepository>(),
        deleteProductUseCase: getIt<DeleteMenuProductFromFireStoreUseCase>(),
      ));

  getIt.registerFactory<EditingProductBloc>(() => EditingProductBloc(
        getSingleProductUseCase: getIt<GetSingleProductUseCase>(),
        getMenuCategoriesUseCase: getIt<GetMenuCategoriesUseCase>(),
        updateProduct: getIt<UpdateMenuProductFromFireStoreUseCase>(),
        uploadAndGetImage: getIt<UploadAndGetImageToFireStoreUseCase>(),
      ));

  getIt.registerFactory<AddNewProductBloc>(() => AddNewProductBloc(
        getMenuCategoriesUseCase: getIt<GetMenuCategoriesUseCase>(),
        uploadAndGetImageToFireStoreUseCase:
            getIt<UploadAndGetImageToFireStoreUseCase>(),
        addNewProductToFireStoreUseCase:
            getIt<AddNewProductToFireStoreUseCase>(),
      ));

  /// repositories
  getIt.registerLazySingleton<Repository>(() => RepositoryImpl(
        dao: getIt<OrdersDao>(),
        fireBaseService: getIt<FireBaseService>(),
      ));

  getIt.registerLazySingleton<MenuListRepository>(() => MenuListRepositoryImpl(
        dao: getIt<MenuProductsDao>(),
        fireBaseService: getIt<FireBaseService>(),
      ));

  /// use cases
  getIt.registerLazySingleton<GetOrdersListUseCase>(
      () => GetOrdersListUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<SyncOrdersListUseCase>(
      () => SyncOrdersListUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<ClearAllOrdersUseCase>(
      () => ClearAllOrdersUseCase(getIt<OrdersDao>()));

  getIt.registerLazySingleton<GetOrdersListFromFireStoreUseCase>(
      () => GetOrdersListFromFireStoreUseCase(getIt<FireBaseService>()));

  getIt.registerLazySingleton<GetProductsByOrderIdUseCase>(
      () => GetProductsByOrderIdUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<GetSingleProductUseCase>(
      () => GetSingleProductUseCase(getIt<MenuProductsDao>()));

  getIt.registerLazySingleton<GetMenuCategoriesUseCase>(
      () => GetMenuCategoriesUseCase(getIt<MenuListRepository>()));

  getIt.registerLazySingleton<UploadAndGetImageToFireStoreUseCase>(
      () => UploadAndGetImageToFireStoreUseCase(getIt<FireBaseService>()));

  getIt.registerLazySingleton<AddNewProductToFireStoreUseCase>(
      () => AddNewProductToFireStoreUseCase(getIt<FireBaseService>()));

  getIt.registerLazySingleton<DeleteMenuProductFromFireStoreUseCase>(
      () => DeleteMenuProductFromFireStoreUseCase(getIt<FireBaseService>()));

  getIt.registerLazySingleton<UpdateMenuProductFromFireStoreUseCase>(
      () => UpdateMenuProductFromFireStoreUseCase(getIt<FireBaseService>()));

  /// database
  getIt.registerSingleton<AppDataBase>(AppDataBase.getInstance);

  getIt.registerSingletonAsync<Database>(
      () => getIt<AppDataBase>().getDataBase());

  getIt.registerLazySingleton<MenuProductsDao>(
      () => MenuProductsDao(getIt<Database>()));

  getIt.registerLazySingleton<OrdersDao>(() => OrdersDao(getIt<Database>()));

  /// others
  getIt.registerLazySingleton<FireBaseService>(() => FireBaseServiceImpl());
}

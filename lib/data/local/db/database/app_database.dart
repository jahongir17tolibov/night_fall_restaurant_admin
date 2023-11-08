import 'package:night_fall_restaurant_admin/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/order_products_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/orders_list_entity.dart';
import 'package:night_fall_restaurant_admin/utils/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDataBase {
  static AppDataBase getInstance = AppDataBase._init();

  static const String _dataBaseName = 'night_fall_admin.db';
  static const int _databaseVersion = 1;
  Database? _database;

  AppDataBase._init();

  Future<Database> getDataBase() async {
    _database ??= await getDatabaseInstance(dataBaseName: _dataBaseName);
    return _database!;
  }

  Future<Database> getDatabaseInstance({
    required String dataBaseName,
  }) async {
    String dataBasePath = await getDatabasePath();
    return await openDatabase(
      dataBasePath,
      version: _databaseVersion,
      onCreate: onCreateDatabase,
    );
  }

  Future<void> onCreateDatabase(Database db, int version) async {
    await db.execute("""
    CREATE TABLE ${OrdersListEntity.TABLE_NAME}(
                    ${OrdersListEntity.CM_ID} $idType,
                    ${OrdersListEntity.CM_ORDER_ID} $stringType,
                    ${OrdersListEntity.CM_TABLE_NUMBER} $stringType,
                    ${OrdersListEntity.CM_SEND_TIME} $stringType,
                    ${OrdersListEntity.CM_TOTAL_PRICE} $stringType
        )""");

    await db.execute("""
    CREATE TABLE ${OrderProductsEntity.TABLE_NAME}(
                    ${OrderProductsEntity.CM_ID} $idType,
                    ${OrderProductsEntity.CM_ORDER_UNIQUE_ID} $stringType,
                    ${OrderProductsEntity.CM_PRODUCT_NAME} $stringType,
                    ${OrderProductsEntity.CM_IMAGE} $stringType,
                    ${OrderProductsEntity.CM_PRICE} $stringType,
                    ${OrderProductsEntity.CM_WEIGHT} $stringType,
                    ${OrderProductsEntity.CM_AMOUNT} $stringType
        )""");

    await db.execute("""
      CREATE TABLE ${MenuProductsEntity.TABLE_NAME}(
                      ${MenuProductsEntity.CM_ID} $idType,
                      ${MenuProductsEntity.CM_PRODUCT_NAME} $stringType,
                      ${MenuProductsEntity.CM_IMAGE} $stringType,
                      ${MenuProductsEntity.CM_PRICE} $stringType,
                      ${MenuProductsEntity.CM_WEIGHT} $stringType,
                      ${MenuProductsEntity.CM_PRODUCT_CATEGORY_ID} $stringType
        )""");

    await db.execute("""
      CREATE TABLE ${MenuCategoriesEntity.TABLE_NAME}(
                      ${MenuCategoriesEntity.CM_ID} $idType,
                      ${MenuCategoriesEntity.CM_CATEGORY_NAME} $stringType,
                      ${MenuCategoriesEntity.CM_CATEGORY_ID} $stringType
        )""");
  }

  Future<String> getDatabasePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _dataBaseName);
  }
}

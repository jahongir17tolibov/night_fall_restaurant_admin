import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/editing_menu_product_model.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/menu_products/get_menu_list_response.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/orders/get_orders_list_response.dart';

class FireBaseServiceImpl extends FireBaseService {
  static final _fireStore = FirebaseFirestore.instance;
  static const String _ordersCollectionPath = 'orders';
  static const String _menuCollectionPath = 'products_menu';
  static const String _menuDocsPath = '1_categories';
  static const String _menuProductsField = 'menu_products';

  @override
  Future<List<GetOrdersListResponse>> getOrdersList() async {
    try {
      final ordersQuery =
          await _fireStore.collection(_ordersCollectionPath).get();
      final docsCollect = ordersQuery.docs;

      if (docsCollect.isNotEmpty) {
        return docsCollect
            .map((it) => GetOrdersListResponse.fromMap(it.data()))
            .toList();
      } else {
        throw Exception('Document doesn`t exist');
      }
    } on FirebaseException catch (fireException) {
      throw Exception(fireException.message);
    }
  }

  @override
  Future<GetMenuListResponse> getMenuList() async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _fireStore.collection(_menuCollectionPath).doc(_menuDocsPath);
      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        return GetMenuListResponse.fromMap(data);
      } else {
        throw Exception('Document doesn`t exist');
      }
    } on FirebaseException catch (fireException) {
      throw Exception(fireException.message);
    }
  }

  @override
  Future<void> addNewProduct(EditingMenuProductsModel product) async {
    try {
      final DocumentReference documentReference =
          _fireStore.collection(_menuCollectionPath).doc(_menuDocsPath);
      DocumentSnapshot documentSnapshot = await documentReference.get();

      List<dynamic> currentMenuProductsField =
          documentSnapshot[_menuProductsField];

      currentMenuProductsField.add(product.toMap());
      await documentReference
          .update({_menuProductsField: currentMenuProductsField});
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateProduct(EditingMenuProductsModel product) async {
    try {
      final DocumentReference documentReference =
          _fireStore.collection(_menuCollectionPath).doc(_menuDocsPath);
      DocumentSnapshot documentSnapshot = await documentReference.get();

      List<dynamic> currentMenuProductsField =
          documentSnapshot[_menuProductsField];

      int index = currentMenuProductsField.indexWhere(
          (menuProduct) => menuProduct["fireId"] == product.fireId);
      print(index);

      if (index != -1) {
        print("index != -1      works");
        Map<String, dynamic> menuProductMap = currentMenuProductsField[index];
        menuProductMap = product.toMap();
        currentMenuProductsField[index] = menuProductMap;

        await documentReference
            .update({_menuProductsField: currentMenuProductsField});
      } else {
        throw Exception('Product not found');
      }
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteMenuProduct(String productName) async {
    try {
      final DocumentReference documentReference =
          _fireStore.collection(_menuCollectionPath).doc(_menuDocsPath);
      DocumentSnapshot documentSnapshot = await documentReference.get();

      List<dynamic> currentMenuProductsField =
          documentSnapshot[_menuProductsField];

      currentMenuProductsField
          .removeWhere((product) => product['name'] == productName);

      await documentReference
          .update({_menuProductsField: currentMenuProductsField});
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadImage(File imageFile, String productName) async {
    final int milliseconds = DateTime.now().millisecondsSinceEpoch;
    final String imageName = "${productName}_$milliseconds";
    try {
      Reference reference =
          FirebaseStorage.instance.ref().child("images/$imageName.jpg");
      UploadTask uploadTask = reference.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}

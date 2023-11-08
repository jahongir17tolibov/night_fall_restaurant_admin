package com.example.night_fall_restaurant_admin.domain.repository

import com.example.night_fall_restaurant_admin.data.local.dao.ProductsDao
import com.example.night_fall_restaurant_admin.data.remote.firestore.FireStoreService
import com.example.night_fall_restaurant_admin.data.remote.model.SendProductModel
import com.example.night_fall_restaurant_admin.mapper.toProductEntity
import com.example.night_fall_restaurant_admin.mapper.toSendProducts
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class RepositoryImpl(
    private val dao: ProductsDao,
    private val fireStoreService: FireStoreService
) : Repository {

    override suspend fun syncProducts() {
        try {
            val products = dao.getProductsListNotReactive().map { it.toSendProducts() }

            if (products.isNotEmpty()) products.forEach {
                val getImageUrl = fireStoreService.uploadImageAndGetUrl(it.image!!)
                fireStoreService.sendDataToFireStore(it.copy(image = getImageUrl))
            }

            dao.clearAllProductsNative()

        } catch (e: Exception) {
            throw Exception(e)
        }
    }

    override suspend fun insertProductToDb(product: SendProductModel) = try {
        dao.insertProductsList(product.toProductEntity())
    } catch (e: Exception) {
        throw Exception(e)
    }

    override suspend fun getProductFromDb(): Flow<List<SendProductModel>> =
        dao.getProductsList().map { list ->
            list.map {
                it.toSendProducts()
            }
        }

    override suspend fun clearAllProducts() = dao.clearAllProductsNative()

    override suspend fun uploadGetImage(imagePath: String): String =
        fireStoreService.uploadImageAndGetUrl(imagePath)

}
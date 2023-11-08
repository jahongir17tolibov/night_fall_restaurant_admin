package com.example.night_fall_restaurant_admin.domain.repository

import com.example.night_fall_restaurant_admin.data.remote.model.SendProductModel
import kotlinx.coroutines.flow.Flow

interface Repository {
    suspend fun syncProducts()

    suspend fun insertProductToDb(product: SendProductModel)

    suspend fun getProductFromDb(): Flow<List<SendProductModel>>

    suspend fun clearAllProducts()

    suspend fun uploadGetImage(imagePath: String): String

}
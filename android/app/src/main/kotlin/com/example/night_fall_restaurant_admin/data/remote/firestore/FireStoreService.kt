package com.example.night_fall_restaurant_admin.data.remote.firestore

import com.example.night_fall_restaurant_admin.data.remote.model.SendProductModel
import kotlinx.coroutines.flow.Flow

interface FireStoreService {

    suspend fun sendDataToFireStore(sendProductModel: SendProductModel)

    suspend fun getDataFromFireStore(): Flow<List<SendProductModel>>

    suspend fun uploadImageAndGetUrl(filePath: String): String

}
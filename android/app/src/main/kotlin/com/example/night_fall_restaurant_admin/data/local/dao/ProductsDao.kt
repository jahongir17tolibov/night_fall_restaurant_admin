package com.example.night_fall_restaurant_admin.data.local.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.example.night_fall_restaurant_admin.data.local.entities.ProductEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface ProductsDao {

    @Query("SELECT * FROM ${ProductEntity.TABLE_NAME} ORDER BY id ASC")
    fun getProductsList(): Flow<List<ProductEntity>>

    @Query("SELECT * FROM ${ProductEntity.TABLE_NAME} ORDER BY id ASC")
    fun getProductsListNotReactive(): List<ProductEntity>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertProductsList(products: ProductEntity)

    @Query("DELETE FROM ${ProductEntity.TABLE_NAME}")
    suspend fun clearAllProductsNative()

}
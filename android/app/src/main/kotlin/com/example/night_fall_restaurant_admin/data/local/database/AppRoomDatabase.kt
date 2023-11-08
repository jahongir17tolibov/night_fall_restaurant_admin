package com.example.night_fall_restaurant_admin.data.local.database

import androidx.room.Database
import androidx.room.RoomDatabase
import com.example.night_fall_restaurant_admin.data.local.dao.ProductsDao
import com.example.night_fall_restaurant_admin.data.local.entities.ProductEntity

@Database(entities = [ProductEntity::class], version = AppRoomDatabase.DATABASE_VERSION)
abstract class AppRoomDatabase : RoomDatabase() {

    companion object {
        const val DATABASE_NAME: String = "fake_store_db"
        const val DATABASE_VERSION: Int = 1
    }

    abstract fun productsDao(): ProductsDao

}
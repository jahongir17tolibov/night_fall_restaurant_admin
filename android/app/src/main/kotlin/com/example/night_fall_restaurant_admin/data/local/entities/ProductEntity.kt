package com.example.night_fall_restaurant_admin.data.local.entities

import androidx.room.ColumnInfo
import androidx.room.Entity

@Entity(tableName = ProductEntity.TABLE_NAME, primaryKeys = ["id"])
data class ProductEntity(
    @ColumnInfo(name = "id")
    val id: Int? = null,
    @ColumnInfo(name = "fire_id")
    val fireId: String,
    @ColumnInfo(name = "name")
    val name: String,
    @ColumnInfo(name = "image")
    val image: String,
    @ColumnInfo(name = "price")
    val price: String,
    @ColumnInfo(name = "weight")
    val weight: String,
    @ColumnInfo(name = "product_category_id")
    val productCategoryId: String,
) {
    companion object {
        const val TABLE_NAME: String = "product_from_dart"
    }
}

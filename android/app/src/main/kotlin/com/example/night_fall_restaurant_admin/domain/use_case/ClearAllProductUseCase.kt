package com.example.night_fall_restaurant_admin.domain.use_case

import com.example.night_fall_restaurant_admin.data.local.dao.ProductsDao

class ClearAllProductUseCase(private val dao: ProductsDao) {

    suspend operator fun invoke() = dao.clearAllProductsNative()

}
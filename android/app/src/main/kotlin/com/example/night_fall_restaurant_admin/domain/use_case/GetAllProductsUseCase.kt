package com.example.night_fall_restaurant_admin.domain.use_case

import com.example.night_fall_restaurant_admin.data.local.dao.ProductsDao

class GetAllProductsUseCase(private val dao: ProductsDao) {

    operator fun invoke() = dao.getProductsListNotReactive()

}
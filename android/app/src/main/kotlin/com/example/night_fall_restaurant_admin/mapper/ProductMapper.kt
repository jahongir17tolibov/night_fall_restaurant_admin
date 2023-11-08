package com.example.night_fall_restaurant_admin.mapper

import com.example.night_fall_restaurant_admin.data.local.entities.ProductEntity
import com.example.night_fall_restaurant_admin.data.remote.model.SendProductModel

fun SendProductModel.toProductEntity(): ProductEntity = ProductEntity(
    name = name!!,
    image = image!!,
    price = price!!,
    weight = weight!!,
    productCategoryId = productCategoryId!!
)

fun ProductEntity.toSendProducts(): SendProductModel = SendProductModel(
    name = name,
    image = image,
    price = price,
    weight = weight,
    productCategoryId = productCategoryId
)
package com.example.night_fall_restaurant_admin.data.remote.model

import com.google.firebase.firestore.Exclude

data class SendProductModel(
    val fireId: String? = null,
    val name: String? = null,
    val image: String? = null,
    val price: String? = null,
    val weight: String? = null,
    val productCategoryId: String? = null,
) {

    companion object {
        const val NAME = "name"
        const val FIRE_ID = "fireId"
        const val IMAGE = "image"
        const val PRICE = "price"
        const val WEIGHT = "weight"
        const val PRODUCT_CATEGORY_ID = "product_category_id"
    }

    @Exclude
    fun toHashMap(): Map<String, Any?> {
        return mapOf(
            FIRE_ID to fireId,
            NAME to name,
            IMAGE to image,
            PRICE to price,
            WEIGHT to weight,
            PRODUCT_CATEGORY_ID to productCategoryId,
        )
    }

}

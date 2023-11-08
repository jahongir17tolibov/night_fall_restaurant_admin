package com.example.night_fall_restaurant_admin.data.remote.model

import com.google.firebase.firestore.Exclude

data class SendProductModel(
    val name: String? = null,
    val image: String? = null,
    val price: String? = null,
    val weight: String? = null,
    val productCategoryId: String? = null,
) {

    companion object {
        const val NAME = "name"
        const val IMAGE = "image"
        const val PRICE = "price"
        const val WEIGHT = "weight"
        const val PRODUCT_CATEGORY_ID = "product_category_id"
    }

    @Exclude
    fun toHashMap(): Map<String, String?> {
        return mapOf(
            NAME to name,
            IMAGE to image,
            PRICE to price,
            WEIGHT to weight,
            PRODUCT_CATEGORY_ID to productCategoryId,
        )
    }

}

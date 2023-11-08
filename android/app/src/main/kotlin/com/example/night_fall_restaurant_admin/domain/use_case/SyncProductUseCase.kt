package com.example.night_fall_restaurant_admin.domain.use_case

import com.example.night_fall_restaurant_admin.domain.repository.Repository

class SyncProductUseCase(private val repository: Repository) {

    suspend operator fun invoke() = repository.syncProducts()

}
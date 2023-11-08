package com.example.night_fall_restaurant_admin.connection_manager

sealed interface NetworkStatus {
    data object Available : NetworkStatus
    data object Unavailable : NetworkStatus
}

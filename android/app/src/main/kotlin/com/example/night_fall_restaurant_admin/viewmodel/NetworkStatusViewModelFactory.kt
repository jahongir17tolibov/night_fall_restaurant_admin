package com.example.night_fall_restaurant_admin.viewmodel

import android.os.Build
import androidx.annotation.RequiresApi
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.night_fall_restaurant_admin.connection_manager.NetworkStatusTracker

class NetworkStatusViewModelFactory(private val networkStatusTracker: NetworkStatusTracker) :
    ViewModelProvider.Factory {
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(NetworkStatusViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return NetworkStatusViewModel(networkStatusTracker) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
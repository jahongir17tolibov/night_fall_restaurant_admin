package com.example.night_fall_restaurant_admin.viewmodel

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.night_fall_restaurant_admin.data.remote.model.SendProductModel
import com.example.night_fall_restaurant_admin.domain.repository.Repository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class MainViewModel(private val repository: Repository) : ViewModel() {
    private val _mutableState = MutableStateFlow<List<SendProductModel>>(emptyList())
    val mutableState: StateFlow<List<SendProductModel>> get() = _mutableState.asStateFlow()

    init {
        viewModelScope.launch {
            repository.getProductFromDb().collect { product ->
                Log.d("jt1771tj", product.toString())
                _mutableState.value = product
            }
        }
    }

    fun insertProductToDb(product: SendProductModel) {
        viewModelScope.launch {
            repository.insertProductToDb(product)
        }
    }

    fun syncForTesting(image: String) {
        viewModelScope.launch {
            repository.uploadGetImage(image)
        }
    }

    fun clearAll() {
        viewModelScope.launch {
            repository.clearAllProducts()
        }
    }

}
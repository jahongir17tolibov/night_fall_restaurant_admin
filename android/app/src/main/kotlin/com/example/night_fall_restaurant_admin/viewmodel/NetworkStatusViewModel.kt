package com.example.night_fall_restaurant_admin.viewmodel

import android.os.Build
import androidx.annotation.RequiresApi
import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.asLiveData
import com.example.night_fall_restaurant_admin.connection_manager.NetworkStatusTracker
import com.example.night_fall_restaurant_admin.connection_manager.statusMap
import kotlinx.coroutines.Dispatchers.IO

sealed interface NetworkState {
    data object Success : NetworkState
    data object Error : NetworkState
}

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class NetworkStatusViewModel(networkStatusTracker: NetworkStatusTracker) : ViewModel() {

    val state: LiveData<NetworkState> = networkStatusTracker.networkStatus.statusMap(
        onUnavailable = { NetworkState.Error },
        onAvailable = { NetworkState.Success },
    ).asLiveData(IO)

}
package com.example.night_fall_restaurant_admin.connection_manager

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import androidx.annotation.RequiresApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.map

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class NetworkStatusTracker(context: Context) {

    private val connectivityManager: ConnectivityManager =
        context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

    val networkStatus = callbackFlow<NetworkStatus> {

        val networkStatusCallBack =
            object : ConnectivityManager.NetworkCallback() {

                override fun onAvailable(network: Network) {
                    trySend(NetworkStatus.Available)
                }

                override fun onUnavailable() {
                    trySend(NetworkStatus.Unavailable)
                }

                override fun onLost(network: Network) {
                    trySend(NetworkStatus.Unavailable)
                }

            }

        val request = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            .build()
        connectivityManager.registerNetworkCallback(request, networkStatusCallBack)

        awaitClose {
            connectivityManager.unregisterNetworkCallback(networkStatusCallBack)
        }

    }

}

inline fun <Result> Flow<NetworkStatus>.statusMap(
    crossinline onUnavailable: suspend () -> Result,
    crossinline onAvailable: suspend () -> Result,
): Flow<Result> = map { status ->
    when (status) {
        NetworkStatus.Unavailable -> onUnavailable()
        NetworkStatus.Available -> onAvailable()
    }
}
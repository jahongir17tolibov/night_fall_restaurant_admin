package com.example.night_fall_restaurant_admin.worker

import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.example.night_fall_restaurant_admin.domain.use_case.GetAllProductsUseCase
import com.example.night_fall_restaurant_admin.domain.use_case.SyncProductUseCase
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class MyWorker(
    appContext: Context,
    workerParameters: WorkerParameters
) : CoroutineWorker(appContext, workerParameters), KoinComponent {
    private val syncProductUseCase by inject<SyncProductUseCase>()
    private val getAllProductUseCase by inject<GetAllProductsUseCase>()
    override suspend fun doWork(): Result = try {
        if (getAllProductUseCase().isNotEmpty()) {
            syncProductUseCase()
            Log.d("MY_WORKER", "done : syncProductUseCase his job")
        }
        Result.success()
    } catch (e: Exception) {
        Result.retry()
    }
}
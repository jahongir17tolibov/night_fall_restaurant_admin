package com.example.night_fall_restaurant_admin.worker

import android.content.Context
import androidx.work.ListenableWorker
import androidx.work.WorkerFactory
import androidx.work.WorkerParameters
import com.example.night_fall_restaurant_admin.domain.use_case.SyncProductUseCase

//class MyWorkerFactory(private val syncProductUseCase: SyncProductUseCase) : WorkerFactory() {
//
//    override fun createWorker(
//        appContext: Context,
//        workerClassName: String,
//        workerParameters: WorkerParameters
//    ): ListenableWorker? {}
////    = when (workerClassName) {
////        MyWorker::class.java.name -> MyWorker(appContext, workerParameters, syncProductUseCase)
////        else -> null
////    }
//
//
//}
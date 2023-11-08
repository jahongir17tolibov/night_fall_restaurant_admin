package com.example.night_fall_restaurant_admin

import android.app.Application
import android.util.Log
import androidx.work.Configuration
import androidx.work.DelegatingWorkerFactory
import com.example.night_fall_restaurant_admin.domain.di.appModule
import com.example.night_fall_restaurant_admin.domain.di.dataModule
import com.example.night_fall_restaurant_admin.domain.use_case.SyncProductUseCase
import com.google.firebase.FirebaseApp
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import org.koin.core.context.startKoin

class App : Application(),  KoinComponent {

    companion object {
        private lateinit var instance: App
    }

    override fun onCreate() {
        super.onCreate()
        instance = this

        FirebaseApp.initializeApp(instance)

        val koinModules = listOf(
            appModule,
            dataModule
        )

        startKoin {
            androidLogger()
            androidContext(androidContext = instance)
            modules(koinModules)
        }

    }

//    override fun getWorkManagerConfiguration(): Configuration {
//        val myWorkerFactory = DelegatingWorkerFactory()
//
//        myWorkerFactory.addFactory(MyWorkerFactory(syncProductUseCase = syncProductUseCase))
//
//        return Configuration.Builder()
//            .setMinimumLoggingLevel(Log.INFO)
//            .setWorkerFactory(myWorkerFactory)
//            .build()
//    }

}
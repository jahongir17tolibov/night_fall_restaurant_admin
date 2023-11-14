package com.example.night_fall_restaurant_admin.domain.di

import androidx.room.Room
import com.example.night_fall_restaurant_admin.data.local.database.AppRoomDatabase
import com.example.night_fall_restaurant_admin.data.remote.firestore.FireStoreService
import com.example.night_fall_restaurant_admin.data.remote.firestore.FireStoreServiceImpl
import com.example.night_fall_restaurant_admin.domain.repository.Repository
import com.example.night_fall_restaurant_admin.domain.repository.RepositoryImpl
import com.example.night_fall_restaurant_admin.domain.use_case.ClearAllProductUseCase
import com.example.night_fall_restaurant_admin.domain.use_case.GetAllProductsUseCase
import com.example.night_fall_restaurant_admin.domain.use_case.SyncProductUseCase
import com.example.night_fall_restaurant_admin.worker.MyWorker
import org.koin.android.ext.koin.androidApplication
import org.koin.android.ext.koin.androidContext
import org.koin.androidx.workmanager.dsl.worker
import org.koin.dsl.bind
import org.koin.dsl.module

val appModule = module {

    single {
        FireStoreServiceImpl()
    } bind FireStoreService::class

    single { RepositoryImpl(get(), get()) } bind Repository::class

    single { SyncProductUseCase(get()) }

    single { ClearAllProductUseCase(get()) }

    single { GetAllProductsUseCase(get()) }

    worker { MyWorker(androidContext(), get()) }

}

val dataModule = module {

    single {
        Room.databaseBuilder(
            context = androidApplication(),
            klass = AppRoomDatabase::class.java,
            name = AppRoomDatabase.DATABASE_NAME,
        ).fallbackToDestructiveMigration()
            .build()
    }

    single { get<AppRoomDatabase>().productsDao() }

}
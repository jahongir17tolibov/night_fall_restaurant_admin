package com.example.night_fall_restaurant_admin

import android.app.Application

class App : Application() {

    companion object {
        private lateinit var instance: App
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
    }

}
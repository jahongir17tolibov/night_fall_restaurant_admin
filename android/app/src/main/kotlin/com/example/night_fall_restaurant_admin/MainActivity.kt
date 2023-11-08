package com.example.night_fall_restaurant_admin


import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.lifecycleScope
import androidx.work.Constraints
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequest
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.example.night_fall_restaurant_admin.data.remote.model.SendProductModel
import com.example.night_fall_restaurant_admin.domain.repository.RepositoryImpl
import com.example.night_fall_restaurant_admin.viewmodel.MainViewModel
import com.example.night_fall_restaurant_admin.worker.MyWorker
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import org.koin.android.ext.android.get


@RequiresApi(Build.VERSION_CODES.O)
class MainActivity : FlutterActivity() {
    private lateinit var viewModel: MainViewModel

    companion object {
        private const val addedWhenNoConnection =
            "product has been added to the database.\nIt will also be added to the server when there is an internet connection"
        private const val CHANNEL = "night_fall_restaurant_admin_channel"
        private const val INVOKE_METHOD_TEXT = "sync_data_local_and_do_work"
        private lateinit var workManager: WorkManager
        private lateinit var timeWorkRequest: OneTimeWorkRequest
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        /** initialize viewModel **/
        viewModel = ViewModelProvider(
            store = ViewModelStore(),
            factory = object : ViewModelProvider.Factory {
                override fun <T : ViewModel> create(modelClass: Class<T>): T {
                    val repository = RepositoryImpl(fireStoreService = get(), dao = get())
                    return MainViewModel(repository = repository) as T
                }
            },
        )[MainViewModel::class.java]

        val flutterChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        flutterChannel.setMethodCallHandler { call, result ->
            val productModel = SendProductModel()
            /** initialize workManager **/
            workManager = WorkManager.getInstance(this)

            if (call.method == INVOKE_METHOD_TEXT) {
                val name = call.argument<String>(SendProductModel.NAME) ?: "name"
                val image = call.argument<String>(SendProductModel.IMAGE) ?: "image"
                val price = call.argument<String>(SendProductModel.PRICE) ?: "price"
                val weight = call.argument<String>(SendProductModel.WEIGHT) ?: "weight"
                val productCategoryId = call.argument(SendProductModel.PRODUCT_CATEGORY_ID) ?: "id"

                val product = productModel.copy(
                    name = name,
                    price = price,
                    image = image,
                    weight = weight,
                    productCategoryId = productCategoryId
                )

                val list = arrayListOf<SendProductModel>()
                viewModel.insertProductToDb(product)

                viewModel.mutableState.onEach {
                    list.addAll(it)
                    Log.d("jt1771tj", "configureFlutterEngine: $it")
                }.launchIn(lifecycleScope)

                result.success(addedWhenNoConnection)

                setupOneTimeWork()

            } else {
                result.notImplemented()
            }
        }
    }

    private val constraints = Constraints.Builder().run {
        setRequiresBatteryNotLow(false)
        setRequiredNetworkType(NetworkType.CONNECTED)
        build()
    }

    private fun setupOneTimeWork() {
        timeWorkRequest = OneTimeWorkRequestBuilder<MyWorker>()
            .setConstraints(constraints)
            .build()

        workManager.enqueue(timeWorkRequest)
    }

}

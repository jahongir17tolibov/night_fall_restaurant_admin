package com.example.night_fall_restaurant_admin.data.remote.firestore

import android.net.Uri
import com.example.night_fall_restaurant_admin.data.remote.model.SendProductModel
import com.google.firebase.Firebase
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.storage
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.tasks.await
import java.io.File
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class FireStoreServiceImpl : FireStoreService {
    private val fireStoreInstance = FirebaseFirestore.getInstance()

    companion object {
        private const val MENU_COLLECTION_PATH = "products_menu"
        private const val MENU_DOC_PATH = "1_categories"
        private const val MENU_PRODUCTS_FIELD = "menu_products"
    }

    override suspend fun sendDataToFireStore(sendProductModel: SendProductModel) {
        try {
            val productMap = sendProductModel.toHashMap()

            val documentReference = fireStoreInstance
                .collection(MENU_COLLECTION_PATH)
                .document(MENU_DOC_PATH)

            documentReference.update(MENU_PRODUCTS_FIELD, FieldValue.arrayUnion(productMap)).await()
        } catch (e: Exception) {
            throw Exception(e)
        }
    }

    override suspend fun getDataFromFireStore(): Flow<List<SendProductModel>> = flow {
        val productsList: ArrayList<SendProductModel> = arrayListOf()
        val docRef = fireStoreInstance.collection(MENU_COLLECTION_PATH)
        val listener = docRef.get().addOnSuccessListener { query ->
            query.forEach { docs ->
                val products = docs.toObject(SendProductModel::class.java)
                productsList.add(products)
            }
        }.addOnFailureListener {
            throw Exception(it)
        }

        listener.await()
        emit(productsList.toList())

    }

    override suspend fun uploadImageAndGetUrl(filePath: String): String =
        suspendCancellableCoroutine { continuation ->
            val file = File(filePath)
            val uri = Uri.fromFile(file)

            val storageRef = Firebase.storage.reference
            val imageReference = storageRef.child("images/${file.name}")

            val uploadTask = imageReference.putFile(uri)
            uploadTask.continueWithTask { task ->
                if (task.isSuccessful.not()) {
                    task.exception?.let {
                        throw it
                    }
                }
                return@continueWithTask imageReference.downloadUrl
            }.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val downloadUrl = task.result.toString()
                    continuation.resume(downloadUrl)
                } else {
                    continuation.resumeWithException(task.exception!!)
                }
            }
        }
}
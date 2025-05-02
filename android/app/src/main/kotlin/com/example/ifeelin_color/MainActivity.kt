package com.ifeelin_color.ifeelin_color

import android.os.Build
import android.os.Bundle
import android.window.OnBackInvokedDispatcher
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Handle OnBackInvokedCallback for Android 14+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            onBackInvokedDispatcher.registerOnBackInvokedCallback(
                OnBackInvokedDispatcher.PRIORITY_DEFAULT
            ) {
                // Call finish() to close activity if no route can be popped
                finish()
            }
        }
    }
}

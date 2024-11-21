package com.example.launcher

import android.content.Intent
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.launcher/app"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openCallOfDuty") {
                val packageName = "com.activision.callofduty.shooter" // Call of Duty Mobile package name
                try {
                    val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
                    if (launchIntent != null) {
                        startActivity(launchIntent)
                        result.success(null)
                    } else {
                        result.error("UNAVAILABLE", "Call of Duty Mobile not installed", null)
                    }
                } catch (e: PackageManager.NameNotFoundException) {
                    result.error("UNAVAILABLE", "Call of Duty Mobile not found", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
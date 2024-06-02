package com.example.sos

import android.os.Bundle
import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sendSms"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "send") {
                val num = call.argument<String>("phone")
                val msg = call.argument<String>("msg")
                if (num != null && msg != null) {
                    sendSMS(num, msg, result)
                } else {
                    result.error("ArgumentError", "Phone number or message is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSMS(phoneNo: String, msg: String, result: MethodChannel.Result) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNo, null, msg, null, null)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", null)
        }
    }
}

package com.example.hr_moi

import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.IsoDep
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL = "nfc/methods"
    private val EVENT_CHANNEL = "nfc/events"

    private var nfcAdapter: NfcAdapter? = null
    private var pendingIntent: PendingIntent? = null
    private var intentFiltersArray: Array<IntentFilter>? = null
    private var techListsArray: Array<Array<String>>? = null

    @Volatile
    private var latestTag: Tag? = null
    private var eventSink: EventChannel.EventSink? = null
    private val executor = Executors.newSingleThreadExecutor()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)

        val intent = Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_MUTABLE)

        techListsArray = arrayOf(arrayOf(IsoDep::class.java.name))
        intentFiltersArray = arrayOf(IntentFilter(NfcAdapter.ACTION_TECH_DISCOVERED))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startListening" -> {
                        enableForegroundDispatch()
                        result.success(true)
                    }
                    "stopListening" -> {
                        disableForegroundDispatch()
                        result.success(true)
                    }
                    "sendApdu" -> {
                        val arg = call.arguments
                        if (arg is ByteArray) {
                            sendApduToTag(arg) { respHex, err ->
                                if (err != null) result.error("APDU_ERROR", err, null)
                                else result.success(respHex)
                            }
                        } else {
                            result.error("INVALID_ARGUMENT", "Expected Uint8List (byte array)", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val action = intent.action
        if (action == NfcAdapter.ACTION_TECH_DISCOVERED || action == NfcAdapter.ACTION_TAG_DISCOVERED) {
            val tag = intent.getParcelableExtra<Tag>(NfcAdapter.EXTRA_TAG)
            latestTag = tag
            eventSink?.success(mapOf("event" to "tag_discovered", "id" to bytesToHex(tag?.id)))
        }
    }

    private fun enableForegroundDispatch() {
        nfcAdapter?.enableForegroundDispatch(this, pendingIntent, intentFiltersArray, techListsArray)
    }

    private fun disableForegroundDispatch() {
        nfcAdapter?.disableForegroundDispatch(this)
    }

    private fun sendApduToTag(apdu: ByteArray, callback: (String?, String?) -> Unit) {
        val tag = latestTag
        if (tag == null) {
            callback(null, "No NFC tag available. Bring the tag close first.")
            return
        }

        executor.execute {
            var iso: IsoDep? = null
            try {
                iso = IsoDep.get(tag)
                if (iso == null) {
                    callback(null, "IsoDep not supported on this tag.")
                    return@execute
                }
                iso.connect()
                iso.timeout = 5000
                val resp = iso.transceive(apdu)
                callback(bytesToHex(resp), null)
            } catch (e: Exception) {
                callback(null, e.message ?: "Unknown error during transceive")
            } finally {
                try { iso?.close() } catch (_: Exception) {}
            }
        }
    }

    private fun bytesToHex(bytes: ByteArray?): String? {
        if (bytes == null) return null
        val sb = StringBuilder()
        for (b in bytes) sb.append(String.format("%02X", b))
        return sb.toString()
    }

    override fun onDestroy() {
        super.onDestroy()
        executor.shutdownNow()
    }
}

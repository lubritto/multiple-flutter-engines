package dev.flutter.multipleflutters

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class FlutterEngineProvider(private val context: Context) {
    private val engines = FlutterEngineGroup(context)
    private val uiLessEngine = UiLessEngine()

    init {
//        uiLessEngine.initializeEngine(this)
    }

    fun provideDeeplinkFlutterEngine(deeplink: String): FlutterEngine {
        val dartEntrypoint: DartExecutor.DartEntrypoint =
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "main"
            )
        return engines.createAndRunEngine(context, dartEntrypoint, deeplink)
    }

    fun provideFlutterEngine(entrypoint: String): FlutterEngine {
        val dartEntrypoint: DartExecutor.DartEntrypoint =
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                entrypoint
            )
        return engines.createAndRunEngine(context, dartEntrypoint)
    }

    fun openDeeplink(deeplink: String, context: Context) {
        val intent = Intent(context, TalabatFlutterActivity::class.java)
        intent.putExtra("deeplink", deeplink)
        context.startActivity(intent)
    }

    fun canOpenDeeplink(deeplink: String, callback: (Boolean) -> Unit) {
        val channel = uiLessEngine.getChannel(DeeplinkNavigationMethodChannel::class.java)
        channel?.callCanOpenDeeplink(deeplink, callback)
    }
}

class TalabatFlutterActivity : FlutterActivity() {
    private val talabatEngine: TalabatFlutterEngine by lazy {
        DeeplinkEngine(intent.getStringExtra("deeplink")!!).apply {
            initializeEngine((applicationContext as App).provider)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        talabatEngine.onAttach(talabatEngine.engine!!.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        super.onDestroy()
        talabatEngine.onDetach()
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return talabatEngine.engine
    }
}

interface PlatformChannel {
    fun onAttach(binaryMessenger: BinaryMessenger)
    fun onDetach()
}

abstract class TalabatFlutterEngine : PlatformChannel {
    internal var engine: FlutterEngine? = null
    protected abstract val channels: List<PlatformChannel>

    abstract fun initializeEngine(provider: FlutterEngineProvider)

    override fun onAttach(binaryMessenger: BinaryMessenger) {
        channels.forEach { channel -> channel.onAttach(binaryMessenger) }
    }

    override fun onDetach() {
        channels.forEach { channel -> channel.onDetach() }
        engine?.destroy()
    }

    fun <T : PlatformChannel> getChannel(klass: Class<T>): T? {
        return channels.filterIsInstance(klass).firstOrNull()
    }
}

class UiLessEngine : TalabatFlutterEngine() {
    override val channels: List<PlatformChannel> = listOf(
        DeeplinkNavigationMethodChannel()
    )

    override fun initializeEngine(provider: FlutterEngineProvider) {
        val engine = provider.provideFlutterEngine("uiLessMain")
        this.engine = engine
        onAttach(engine.dartExecutor.binaryMessenger)
    }
}

class DeeplinkEngine(private val deeplink: String) : TalabatFlutterEngine() {
    override val channels: List<PlatformChannel> = listOf(
        DeeplinkNavigationMethodChannel(),
    )

    override fun initializeEngine(provider: FlutterEngineProvider) {
        val engine = provider.provideDeeplinkFlutterEngine(deeplink)
        this.engine = engine
    }
}

class DeeplinkNavigationMethodChannel : PlatformChannel, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "canOpenDeeplink" -> {
                result.success(null)
            }
            "openDeeplink" -> {
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    fun callCanOpenDeeplink(deeplink: String, callback: (Boolean) -> Unit) {
        channel?.invokeMethod("canOpenDeeplink", deeplink, object : MethodChannel.Result {
            override fun success(result: Any?) {
                callback(result == true)
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                callback(false)
            }

            override fun notImplemented() {
                callback(false)
            }
        })
    }

    override fun onAttach(binaryMessenger: BinaryMessenger) {
        channel = MethodChannel(binaryMessenger, "com.talabat.flutter/deeplinkNavigation")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetach() {
        channel?.setMethodCallHandler(null)
        channel = null
    }
}

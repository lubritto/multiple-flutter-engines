package dev.flutter.multipleflutters

import android.app.Application
import io.flutter.embedding.engine.FlutterEngineGroup

/**
 * Application class for this app.
 *
 * This holds onto our engine group.
 */
class App : Application() {
    lateinit var engines: FlutterEngineGroup

    lateinit var provider: FlutterEngineProvider

    override fun onCreate() {
        super.onCreate()

        provider = FlutterEngineProvider(this)

        engines = FlutterEngineGroup(this)
    }
}

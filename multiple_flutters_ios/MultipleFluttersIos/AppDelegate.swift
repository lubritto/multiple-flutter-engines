// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Flutter
import FlutterPluginRegistrant
import UIKit

/// The app's UIApplicationDelegate.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let engines = FlutterEngineGroup(name: "multiple-flutters", project: nil)
    var communicationEngine: FlutterEngine!
    var channel: FlutterMethodChannel?
    var dataSyncEventSinkChannel: FlutterMethodChannel?
    let events = EventManager();
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        communicationEngine = engines.makeEngine(withEntrypoint: "uiLessMain", libraryURI: nil)
        GeneratedPluginRegistrant.register(with: communicationEngine)
        channel = FlutterMethodChannel(name: "data-sync", binaryMessenger: communicationEngine!.binaryMessenger)
        dataSyncEventSinkChannel = FlutterMethodChannel(name: "data-sync-event-sink", binaryMessenger: communicationEngine!.binaryMessenger)
        dataSyncEventSinkChannel!.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            self.events.trigger(eventName: "data-sync-event", information: [call.method:call.arguments])
        }
        
#if DEBUG
        let isDebug = true
#else
        let isDebug = false
#endif
        if isDebug {
            NSLog(
                "📣 NOTICE: the memory and CPU costs for Flutter engine groups are significantly greater in debug builds.  See also: https://github.com/dart-lang/sdk/issues/36097"
            )
        } else {
            NSLog(
                "📣 NOTICE: the memory and CPU costs for Flutter engine groups are significantly less here than in debug builds.  See also: https://github.com/dart-lang/sdk/issues/36097"
            )
        }
        
        return true
    }
    
    func application(
        _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
        _ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
}

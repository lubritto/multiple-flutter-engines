import Flutter
import FlutterPluginRegistrant
import Foundation

class SingleFlutterViewController: FlutterViewController, FlutterStreamHandler {
    private var sink: FlutterEventSink?
    private var dataSyncChannel: FlutterMethodChannel?
    private var dataSyncEventChannel: FlutterEventChannel?
    private var navigationChannel: FlutterMethodChannel?
    
    init(withEntrypoint entryPoint: String?) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let newEngine = appDelegate.engines.makeEngine(withEntrypoint: "deeplinkMain", libraryURI: nil, initialRoute: entryPoint)
        GeneratedPluginRegistrant.register(with: newEngine)
        super.init(engine: newEngine, nibName: nil, bundle: nil)
    }
    
    init(withEngine engine: FlutterEngine) {
        super.init(engine: engine, nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navController = self.navigationController!
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let uiLessChannel = appDelegate.channel
        
        navigationChannel = FlutterMethodChannel(name: "deeplink-navigation", binaryMessenger: self.engine!.binaryMessenger)
        navigationChannel!.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            let navController = self.navigationController!
            navController.view.backgroundColor = .white
            navController.setNavigationBarHidden(false, animated: true)

            let vc = SingleFlutterViewController(withEntrypoint: "/screen1")
            navController.pushViewController(vc, animated: true)
            result(true)
        }
        
        dataSyncChannel = FlutterMethodChannel(name: "data-sync", binaryMessenger: self.engine!.binaryMessenger)
        dataSyncChannel!.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            // receiving from flutter
            uiLessChannel?.invokeMethod(call.method, arguments: call.arguments) { callbackResult in
                result(callbackResult)
            }
        }
        
        dataSyncEventChannel = FlutterEventChannel(name: "data-sync-event", binaryMessenger: self.engine!.binaryMessenger)
        dataSyncEventChannel!.setStreamHandler(self)
        
        appDelegate.events.listenTo(eventName: "data-sync-event", action: { information in
            if (self.sink != nil) {
                self.sink!(information)
            }
        });
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}

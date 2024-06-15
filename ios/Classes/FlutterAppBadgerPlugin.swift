
import Flutter
import UIKit
import UserNotifications

public class FlutterAppBadgerPlugin: NSObject, FlutterPlugin {
    
    public static func register(
        with registrar: FlutterPluginRegistrar
    ) {
        let channel = FlutterMethodChannel(
            name: "g123k/flutter_app_badger", 
            binaryMessenger: registrar.messenger()
        )
        let instance = FlutterAppBadgerPlugin()
        registrar.addMethodCallDelegate(
            instance, 
            channel: channel
        )
    }
    
    public func handle(
        _ call: FlutterMethodCall, 
        result: @escaping FlutterResult
    ) {
        let method = PluginEvent(rawValue: call.method)
        switch method {
        case .updateBadgeCount:
            if let args = call.arguments as? [String: Any],
               let count = args["count"] as? NSNumber {
                if #available(iOS 16.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(count.intValue) { error in
                        // Handle errors here if necessary
                    }
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = count.intValue
                }
            }
            result(nil)
        case .removeBadge:
            if #available(iOS 16.0, *) {
                UNUserNotificationCenter.current().setBadgeCount(0) { error in
                    // Handle errors here if necessary
                }
            } else {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            result(nil)
        case .isAppBadgeSupported:
            result(true)
        case .getBadgeCount:
            result(UIApplication.shared.applicationIconBadgeNumber)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import Firebase 
import UserNotifications
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let settingsChannel = FlutterMethodChannel(name: "com.ifeelin_color.ifeelin_color/settings",
                                              binaryMessenger: controller.binaryMessenger)
    settingsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "openAppSettings" {
        self.openAppSettings(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
     GMSServices.provideAPIKey("AIzaSyDYnSt88OMQBytz2HAtEGjeiEMQ6HcwpQY")
    FirebaseApp.configure()
    
    GeneratedPluginRegistrant.register(with: self)
     if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
   Messaging.messaging().delegate = self
    
    application.registerForRemoteNotifications()
}
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  private func openAppSettings(result: FlutterResult) {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Cannot open settings",
                            details: nil))
      }
    } else {
      result(FlutterError(code: "UNAVAILABLE",
                          message: "Cannot open settings URL",
                          details: nil))
    }
  }

   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

   Messaging.messaging().apnsToken = deviceToken
    print("APNs Token Set: \(deviceToken)")
   super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
 }
  override func applicationDidEnterBackground(_ application: UIApplication){
   application.applicationIconBadgeNumber = 0
}
  

 
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("%@: failed to register for remote notifications: %@", self.description, error.localizedDescription)
    }
    
 
    
   override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NSLog("%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo)
       
        completionHandler()
    }
    
   override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NSLog("%@: will present notification: %@", self.description, notification.request.content.userInfo)

        completionHandler([.badge, .sound, .alert])
    }
    
   override func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("%@: did receive remote notification completionhandler: %@", self.description, userInfo)
        completionHandler(UIBackgroundFetchResult.noData)
    }
    
    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        NSLog("pushNotificationTapped: customExtras: ", customExtras)
    }
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    // Notify your backend server about the new FCM token
  }
}

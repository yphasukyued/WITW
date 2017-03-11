import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let vc = ViewController()
        window?.rootViewController = vc
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(red: 51/255, green: 0/255, blue: 51/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1)
        
        _ = Pushbots(appId:"58b4a2f34a9efaf70a8b4569", prompt: true);
        //Track Push notification opens while launching the app form it
        Pushbots.sharedInstance().trackPushNotificationOpened(withPayload: launchOptions);
        
        
        if launchOptions != nil {
            if let userInfo = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                //Capture notification data e.g. badge, alert and sound
                
                if let aps = userInfo["aps"] as? NSDictionary {
                    Pushbots.openURL(userInfo as! [AnyHashable : Any])
                    
                    let alert_message = aps["alert"] as! String
                    let alert = UIAlertController(title: "Push notification title",
                                                  message: alert_message,
                                                  preferredStyle: .alert)
                    
                    let defaultButton = UIAlertAction(title: "OK",
                                                      style: .default) {(_) in
                                                        // your defaultButton action goes here
                    }
                    
                    alert.addAction(defaultButton)
                    self.window?.rootViewController?.present(alert, animated: true) {
                        // completion goes here
                    }
                }
            }
        }
        
        //Notifications extensions
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // actions based on whether notifications were authorized or not
            }
            application.registerForRemoteNotifications()
            
        } else {
            // Fallback on earlier versions
        }
        setNotificationsCategories()
        
        return true
    }
    
    func setNotificationsCategories() {
        if #available(iOS 10.0, *) {
            
            let readNow = UNNotificationAction(
                identifier: "ReadNow",
                title: "Read Now 📰 "
            )
            let later = UNNotificationAction(
                identifier: "Later",
                title: "Later",
                options: [.destructive]
            )
            let newscategory = UNNotificationCategory(
                identifier: "News",
                actions: [readNow, later],
                intentIdentifiers: []
            )
            
            let shop = UNNotificationAction(
                identifier: "Shop",
                title: "Go Shopping 🛍️"
            )
            let dismiss = UNNotificationAction(
                identifier: "dismiss",
                title: "Dismiss",
                options: [.destructive]
            )
            let categoryz = UNNotificationCategory(
                identifier: "Shopping",
                actions: [shop, dismiss],
                intentIdentifiers: []
            )
            
            UNUserNotificationCenter.current().setNotificationCategories([newscategory,categoryz])
            UNUserNotificationCenter.current().delegate = self
        } else {
            
            
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    // MARK: - push Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // This method will be called everytime you open the app
        // Register the deviceToken on Pushbots
        Pushbots.sharedInstance().register(onPushbots: deviceToken);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification Registration Error \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if application.applicationState == .inactive  {
            Pushbots.sharedInstance().trackPushNotificationOpened(withPayload: userInfo);
        }
        
        //The application was already active when the user got the notification, just show an alert.
        //That should *not* be considered open from Push.
        if application.applicationState == .active  {
            
            //Capture notification data e.g. badge, alert and sound
            
            //IF you didn't send title for the notification
            //if let aps = userInfo["aps"] as? NSDictionary {
            //   let alert_message = aps["alert"] as! String
            //   let alert = UIAlertController(title: "Push notification title", message: alert_message, preferredStyle: .alert)
            
            //IF you send title for the notification.
            if let aps = userInfo["aps"] as? NSDictionary {
                
                if let alertDic = aps["alert"] as? NSDictionary {
                    let alert_message = alertDic["body"] as! String
                    
                    let alert = UIAlertController(title: alertDic["title"] as? String, message: alert_message, preferredStyle: .alert)
                    
                    let defaultButton = UIAlertAction(title: "OK", style: .default) {(_) in
                        // your defaultButton action goes here
                    }
                    
                    alert.addAction(defaultButton)
                    self.window?.rootViewController?.present(alert, animated: true) {
                        // completion goes here
                    }
                }
            }
            
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Shop":
            print("Shop !!")
        case "ReadNow":
            print("Read Now")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}


//
//  AppDelegate.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit

import Bolts
import Parse

import FBSDKCoreKit

var isFirstTime: Bool!



// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to useevetimefolnum Crash Reporting - uncomment this line
// import ParseCrashReporting

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        

        
        Parse.enableLocalDatastore()
        UINavigationBar.appearance().barTintColor = UIColorFromRGB("00ADEF", alpha: 0.8)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "BLUE TOP.png"), forBarMetrics: .Default)
        
       
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentDate = dateFormatter.stringFromDate(NSDate())
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    
        
        
        UINavigationBar.appearance().translucent = false
        
        UITabBar.appearance().selectedImageTintColor = UIColorFromRGB("ed9f50", alpha: 1.0)
        UITabBar.appearance().backgroundImage = UIImage(named: "DATNEWNEWBOTTOM.png")
        UITabBar.appearance().backgroundColor = UIColor.blackColor()
        UITabBar.appearance().opaque = true
        UITabBar.appearance().alpha = 1
        
        
        println(checkIfDay(currentDate))
        
        if checkIfDay(currentDate) {
            UITabBar.appearance().backgroundImage = nil
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
            UINavigationBar.appearance().setBackgroundImage(UIImage(named: "BLUE TOP.png"), forBarMetrics: .Default)
        }
        
        
        
        // ****************************************************************************
        // Uncomment this line if you want to enable Crash Reporting
        // ParseCrashReporting.enable()
        //
        // Uncomment and fill in with your Parse credentials:
        Parse.setApplicationId("xpzY5qX9i4nh79j0zz663VaKFMBpMsLFUZD1FRIf",
            clientKey: "oeYEc4ojBQvTOfFFGP4qrCrQBq4Qbo5phT0Tap0q")
        
        
  
        
        
        
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************

        PFUser.enableAutomaticUser()

        let defaultACL = PFACL();
        


        
        
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColorFromRGB("00ADEF", alpha: 1.0)
        self.window?.addSubview(view)
    
//        if let username = PFUser.currentUser()?.username {
//            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//            
//            var storyboard = UIStoryboard(name: "Main", bundle: nil)
//            
//            var initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainController") as! UIViewController
//            
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
//        }


        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)

        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)

        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.

            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("kUsernameKey") == nil {
            println("First time opening app")
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            var initialViewController = storyboard.instantiateViewControllerWithIdentifier("Intro1ViewController") as! UIViewController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "kUsernameKey")
        
            
            return true
        }

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                println("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
            } else {
                println("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
            }
        }
    }


    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////

    
    func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject?) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application,
    openURL: url,
    sourceApplication: sourceApplication,
    annotation: annotation)
    }
    
    
    //Make sure it isn't already declared in the app delegate (possible redefinition of func error)
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func checkIfDay(time: String) -> Bool {
        
        var fullName = time
        let fullNameArr = fullName.componentsSeparatedByString(":")
        
        var firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr[1]
        
        if (firstName.toInt()! > 6) && (firstName.toInt()! <= 19) {
            return true
        } else {
            return false
        }
        
        
    }
    
}


extension UITabBar {
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        return sizeThatFits
    }
}
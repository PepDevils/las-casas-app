//
//  AppDelegate.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils on 05/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleSignIn
import Firebase
import FirebaseMessaging

//import FBSDKCoreKit
//import FBSDKShareKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //Iphone Token: cE3x5AWwgSs:APA91bGbZkHkfIC0HKIM1AmkARqNnrpMVSN7djBvpWHF5NNpJUB3C8VAAfojgKnH5v4l_vZDn6R38ffnQkgW9obcoUsxEDwtCnG8jEKNB5Lv1AZauNZCI3pxmBM2lWobSfPUz4NLwCfI
    
    
    var window: UIWindow?
    let API_KEY_GOOGLE_MAPS = "AIzaSyBnrHYLNSDqqHWQb6thXCJULK01yu1Prfk";

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(API_KEY_GOOGLE_MAPS)
        
        //facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginManager().logOut()

        //firebase
        FIRApp.configure()
        
        //let token = FIRInstanceID.instanceID().token()
        let notificationTypes : UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let notificationsSttings = UIUserNotificationSettings(types:notificationTypes, categories:nil)
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationsSttings)
        if let payload = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary, let idHouse = payload["idHouse"] as? String
        {
            MyGlobalVariables.NotifData = idHouse
        }
        //MyGlobalVariables.NotifData = "1001-869"
        if application.applicationIconBadgeNumber > 0
        {
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
        }
        
        //print("TOKEN: \(token) - TOKEN")
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation:annotation)
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("MessageID: \(userInfo["id"]!) - MessageID")
        print(userInfo)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
         FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


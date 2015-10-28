//
//  AppDelegate.swift
//  Antelope
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var mainViewController: MainViewController!
    var window: UIWindow?
    var app: UIApplication = UIApplication.sharedApplication()
    var storyboard: UIStoryboard!
    
    var tutorialStarted: Bool = false
    
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var remoteNotificationsRegistrationSession: NSURLSession!
    var remoteNotificationsRegistrationSessionTask: NSURLSessionDataTask!

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let facebookDeepLinked : Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return facebookDeepLinked
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if !userDefaults.boolForKey("HasLaunchedOnce") {
            userDefaults.setBool(true, forKey: "HasLaunchedOnce")
            userDefaults.setBool(true, forKey: "TrialPeriodActive")
            userDefaults.synchronize()
            
            if let preferences = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
                preferences.setBool(true, forKey: Constants.BLOCKER_PERMISSION_KEY)
                preferences.synchronize()
            }
        }
        
        self.reloadBlocker()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        
        self.window?.rootViewController = mainViewController
        
        self.setupRemoteNotifications()
        
        let facebookLaunched : Bool = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return facebookLaunched
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if (!self.trialActive()) {
            self.mainViewController.showShareWall()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Notifications
    
    func setupRemoteNotifications() {
        print("setting up remote notifications")
        let type: UIUserNotificationType = UIUserNotificationType.Alert
        let settings = UIUserNotificationSettings(forTypes: type, categories: nil)
        
        app.registerUserNotificationSettings(settings)
        app.registerForRemoteNotifications()
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = String(deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        _registerDeviceToken(deviceTokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if let data = userInfo["data"] as? NSDictionary {
            if let id = data["id"] as? NSInteger {
                self.getTrialStatus(id)
            }
        }
    }

    // remote notification in background
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if let data = userInfo["data"] as? NSDictionary {
            if let id = data["id"] as? NSInteger {
                self.getTrialStatus(id)
                completionHandler(UIBackgroundFetchResult.NewData)
            }
        }
    }
    
    func _registerDeviceToken(deviceTokenString: String) {
        print("registering device token remotely", deviceTokenString)
        
        let deviceIdString: String! = UIDevice().identifierForVendor?.UUIDString
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Constants.SERVER_DOMAIN)/users")!)
        request.HTTPMethod = "POST"
        
        let postParams = "device_apn_token=\(deviceTokenString)&device_id=\(deviceIdString)"
        request.HTTPBody = postParams.dataUsingEncoding(NSUTF8StringEncoding)
        
        remoteNotificationsRegistrationSession = NSURLSession.sharedSession()
        remoteNotificationsRegistrationSessionTask = remoteNotificationsRegistrationSession.dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.mainViewController.startTutorial()
                    self.tutorialStarted = true
                })
            }
        }
        
        remoteNotificationsRegistrationSessionTask.resume()
    }
    
    func getTrialStatus(id: NSInteger) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Constants.SERVER_DOMAIN)/users/\(id)/trial_status")!)
        request.HTTPMethod = "GET"
        
        let urlSession = NSURLSession.sharedSession()
        let sessionTask = urlSession.dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                if let trialPeriodActiveString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    print(trialPeriodActiveString)
                    if trialPeriodActiveString.boolValue == false && self.trialActive() {
                        self.finishTrial()
                        
                        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.mainViewController.showShareWall()
                            })
                        }
                    }
                }
            }
        }
        
        sessionTask.resume()
    }
    
    func reloadBlocker() {
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("com.antelope.Antelope-Ad-Blocker.Block-Ads", completionHandler: { (error) -> Void in
            if let error = error {
                print("error:\(error)")
            } else {
                print("loaded successfully")
            }
        })
    }
    
    func finishTrial() {
        print("finishing trial")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "TrialPeriodActive")
        if let preferences = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
            preferences.setBool(false, forKey: Constants.BLOCKER_PERMISSION_KEY)
            preferences.synchronize()
        }
        
        self.reloadBlocker()
    }
    
    func trialActive() -> Bool {
        if let bool: Bool = userDefaults.boolForKey("TrialPeriodActive") {
            print("trial period active?", bool)
            
            return bool
        } else {
            return true
        }
    }
 
}


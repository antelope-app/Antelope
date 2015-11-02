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
class AppDelegate: UIResponder, UIApplicationDelegate, MainControllerDelegate, NotificationSetupFlowDelegate {
    
    var mainViewController: MainViewController!
    var window: UIWindow?
    var app: UIApplication = UIApplication.sharedApplication()
    var storyboard: UIStoryboard!
    
    var tutorialStarted: Bool = false
    
    var user = User()
    
    var userIsPromptedForRemoteNotifications: Bool = false
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var remoteNotificationsRegistrationSession: NSURLSession!
    var remoteNotificationsRegistrationSessionTask: NSURLSessionDataTask!

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let facebookDeepLinked : Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return facebookDeepLinked
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        mainViewController.delegate = self
        
        self.window?.rootViewController = mainViewController
        
        if !userDefaults.boolForKey("HasLaunchedOnce") {
            
            userDefaults.setBool(true, forKey: "HasLaunchedOnce")
            userDefaults.setBool(true, forKey: "TrialPeriodActive")
            userDefaults.setBool(false, forKey: "PromptedForNotifications")
            userDefaults.synchronize()
            
            if let preferences = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
                preferences.setBool(true, forKey: Constants.BLOCKER_PERMISSION_KEY)
                preferences.synchronize()
            }
            
            self.mainViewController.startNotificationSetup()
            self.mainViewController.notificationSetupFlowController.delegate = self
        } else {
            
            user.getByDeviceId({
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        let httpResponse = response as! NSHTTPURLResponse
                        if (data != nil && httpResponse.statusCode != 404) {
                            
                            self.user.initFromData(data!)
                            
                            print(self.user)
                            
                            if (!self.userDefaults.boolForKey("PromptedForNotifications")) {
                                self.mainViewController.startNotificationSetup()
                                self.mainViewController.notificationSetupFlowController.delegate = self
                            } else {
                                self.setupRemoteNotifications()
                                self.mainViewController.trialStateActive()
                                
                                print("is trial done? \(self.user.trial_period)")
                                if self.user.trial_period != nil && self.user.trial_period.boolValue == false {
                                    print("trial is done")
                                    self.finishTrial()
                                }
                            }
                        }
                        else if (data == nil || httpResponse.statusCode == 404) {
                            self.mainViewController.startNotificationSetup()
                            self.mainViewController.notificationSetupFlowController.delegate = self
                        }
                    })
                }
            })
        }
        
        self.reloadBlocker()
        
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
        if let preferences = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
            preferences.synchronize()
            
            if (!self.trialActive() && !preferences.boolForKey(Constants.BLOCKER_PERMISSION_KEY)) {
                self.mainViewController.showShareWall()
            }
        }
        
        if (self.userIsPromptedForRemoteNotifications) {
            userDefaults.setBool(true, forKey: "PromptedForNotifications")
            self.userIsPromptedForRemoteNotifications = false
            
            print("seguing to tutorial")
            self.mainViewController.segueToTutorial({
                self.mainViewController.notificationSetupFlowController.removeFromParentViewController()
                self.mainViewController.notificationSetupFlowController.view.removeFromSuperview()
            })
            
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Notifications
    
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
    
    func notificationSetupDidFinish() {
        self.userIsPromptedForRemoteNotifications = true
        self.setupRemoteNotifications()
    }
    
    func setupRemoteNotifications() {
        print("setting up remote notifications")
        let type: UIUserNotificationType = UIUserNotificationType.Alert
        let settings = UIUserNotificationSettings(forTypes: type, categories: nil)
        
        app.registerUserNotificationSettings(settings)
        app.registerForRemoteNotifications()
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if let data = userInfo["data"] as? NSDictionary {
            self.queryTrialStatusUsingVendorId()
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if let data = userInfo["data"] as? NSDictionary {
            self.queryTrialStatusUsingVendorId()
            completionHandler(UIBackgroundFetchResult.NewData)
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
                })
            }
        }
        
        remoteNotificationsRegistrationSessionTask.resume()
    }
    
    func queryTrialStatusUsingVendorId() {
        
        if !self.trialActive() {
            return
        } else {
            user.getByDeviceId({
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        if (data != nil) {
                            
                            self.user.initFromData(data!)
                            
                            if self.user.trial_period != nil && self.user.trial_period == false {
                                self.finishTrial()
                            }
                        }
                    })
                }
            })
        }
    }
    
    func reloadBlocker() {
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("com.antelope.Antelope-Ad-Blocker.Block-Ads", completionHandler: {
            (error) -> Void in
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
        
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            dispatch_async(dispatch_get_main_queue(), {
                self.mainViewController.showShareWall()
            })
        }
        
        self.reloadBlocker()
    }
    
    func didShareWithSuccess() {
        print("delegate callback in appdelegate, did share with success")
        if let preferences = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
            preferences.setBool(true, forKey: Constants.BLOCKER_PERMISSION_KEY)
            preferences.synchronize()
        }
        
        self.mainViewController.trialStateViewController.updateCounter(0)
        
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


//
//  ViewController.swift
//  Antelope
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {
    @IBOutlet weak var splashView: UIView!
    var tutorialViewController: TutorialViewController!
    var hasLaunchedOnce: Bool!
    var currentDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(self.splashView)
        self.splashView.backgroundColor = UIColor.blackColor()
        
        let currentDate = NSDate()
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce") {
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: currentDate)
            
            let date = NSCalendar.currentCalendar().dateWithEra(1, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second, nanosecond: components.nanosecond)!
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: "firstLaunchDate")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
            hasLaunchedOnce = true;
        }
        else {
            if NSUserDefaults.standardUserDefaults().valueForKey("firstLaunchDate") != nil {
                let minuteThreshold: Double = 3 * 24 * 60
                
                let firstLaunchDateInMinutes = NSUserDefaults.standardUserDefaults().valueForKey("firstLaunchDate") as! NSDate
                let minutesSinceLaunchDate = self.getDifferenceInMinutesSince(firstLaunchDateInMinutes)
                
                print(minuteThreshold)
                
                if Int(minutesSinceLaunchDate) > Int(minuteThreshold) || true {
                    print(minutesSinceLaunchDate)
                    print("show paywall")
                    
                    let shareViewController = ShareViewController()
                    self.addChildViewController(shareViewController)
                    self.view.insertSubview(shareViewController.view, aboveSubview: self.view)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: "firstLaunchDate")
            }
        }
        
        self.startTutorial()
        
        // Auto-reload content blocker when view loads
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("com.antelope.Antelope-Ad-Blocker.Block-Ads") { (error) -> Void in
            if let error = error {
                print("Failed to load with \(error).")
            } else {
                print("Loaded successfully.")
            }
        }
    }
    
    func startTutorial() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tutorialViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialViewController") as? TutorialViewController
        
        self.addChildViewController(tutorialViewController)
        
        tutorialViewController.view.frame = UIScreen.mainScreen().bounds
        self.view.insertSubview(tutorialViewController.view, aboveSubview: self.splashView)
    }
    
    func getDifferenceInMinutesSince(date: NSDate) -> Int {
        let currentDate = NSDate()
        let elapsedTime = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: currentDate, options: []).minute
        
        return elapsedTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


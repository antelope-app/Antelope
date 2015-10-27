//
//  ViewController.swift
//  Antelope
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var splashView: UIView!
    var tutorialViewController: TutorialViewController!
    var hasLaunchedOnce: Bool!
    var currentDate = NSDate()
    
    var shareViewController: ShareViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("main controller view did load")
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(self.splashView)
        self.splashView.backgroundColor = UIColor.whiteColor()
    }
    
    func showShareWall() {
        if shareViewController == nil {
            shareViewController = ShareViewController()
            self.addChildViewController(shareViewController)
            print(self.childViewControllers.count)
            
            self.view.addSubview(shareViewController.view)
        } else {
            shareViewController.present()
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


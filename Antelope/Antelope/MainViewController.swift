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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(self.splashView)
        self.splashView.backgroundColor = UIColor.blackColor()
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce") || true {
            self.startTutorial()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


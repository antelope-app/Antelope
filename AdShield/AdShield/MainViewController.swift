//
//  ViewController.swift
//  AdShield
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {
    @IBOutlet weak var splashView: UIView!
    var tutorialViewController: TutorialViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tutorialViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialViewController") as? TutorialViewController
        
        self.addChildViewController(tutorialViewController)
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(self.splashView)
        self.splashView.backgroundColor = UIColor.blackColor()
        
        tutorialViewController.view.frame = UIScreen.mainScreen().bounds
        self.view.insertSubview(tutorialViewController.view, aboveSubview: self.splashView)
        
        // Auto-reload content blocker when view loads
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("com.adshield.AdShield.AdShield-Extension") { (error) -> Void in
            if let error = error {
                print("Failed to load with \(error).")
            } else {
                print("Loaded successfully.")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


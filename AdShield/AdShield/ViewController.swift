//
//  ViewController.swift
//  AdShield
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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


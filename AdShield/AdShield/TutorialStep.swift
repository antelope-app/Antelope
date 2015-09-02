//
//  TutorialStep.swift
//  AdShield
//
//  Created by Jae Lee on 9/1/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialStep: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func nextStep(sender: UIButton) {
        print("TOUCHED BUTTON")
    }
}

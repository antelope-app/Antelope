//
//  PreNotificationPrompt.swift
//  Antelope
//
//  Created by Jae Lee on 10/30/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation
import UIKit

class PreNotificationPrompt: TutorialStep {
    var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorKit.white
    }
    
    @IBAction func nextStep(sender: UIButton) {
        delegate.nextStep(3)
    }
    
    func initialize() {
    }
}

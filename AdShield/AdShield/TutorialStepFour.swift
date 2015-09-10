//
//  TutorialStepFour.swift
//  Antelope
//
//  Created by Jae Lee on 9/9/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialStepFour: TutorialStep
{
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var header: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorKit.orange
        nextButton = borderButtonStyle(nextButton, options: [ "color": "white" ])
    }
    
    @IBAction func nextStep(sender: UIButton)
    {
        delegate.nextStep(3)
    }
    
    func initialize()
    {
    }
}

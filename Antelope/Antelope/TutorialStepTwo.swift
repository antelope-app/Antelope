//
//  TutorialStepTwo.swift
//  AdShield
//
//  Created by Jae Lee on 9/3/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialStepTwo: TutorialStep
{
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var headline: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nextButton = borderButtonStyle(nextButton, options: [ "color": "white" ])
        self.view.addSubview(nextButton)
        self.view.addSubview(headline)
        
        self.view.backgroundColor = self.colorKit.teal
        
        self.constrainHeader(headline)
        self.constrainButton(nextButton)
        self.view.layoutSubviews()
    }
    
    @IBAction func nextStep(sender: UIButton)
    {
        delegate.nextStep(2)
    }
    
    func initialize()
    {
    }
}
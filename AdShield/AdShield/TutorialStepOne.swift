//
//  TutorialStepOne.swift
//  AdShield
//
//  Created by Jae Lee on 9/2/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialStepOne: TutorialStep
{
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var headline: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let buttonOptions: [String: String] = ["color": "white"]
        nextButton = self.borderButtonStyle(nextButton, options: buttonOptions)
        
        headline.textColor = colorKit.white
        
        self.view.backgroundColor = self.colorKit.magenta
    }
    
    
    @IBAction func nextStep(sender: UIButton)
    {
        print(self.view.frame.size.width)
        delegate.nextStep(1)
    }
    
    override func viewDidAppear(animated: Bool)
    {
    }
    
    func initialize()
    {
    }
}

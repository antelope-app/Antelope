//
//  TutorialStep.swift
//  AdShield
//
//  Created by Jae Lee on 9/1/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

protocol TutorialStepDelegate
{
    func nextStep()
}

class TutorialStep: UIViewController
{
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stepZeroHeader: UITextView!
    @IBOutlet weak var stepZeroSubheader: UITextView!
    
    var delegate: TutorialStepDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nextButton = self.primaryButtonStyle(nextButton)
    }

    @IBAction func nextStep(sender: AnyObject)
    {
        delegate?.nextStep()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
    }
    
    func primaryButtonStyle(button: UIButton) -> UIButton {
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGrayColor().CGColor
        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        return button
    }
}

//
//  TutorialStepThree.swift
//  AdShield
//
//  Created by Jae Lee on 9/3/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialStepThree: TutorialStep
{
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var header: UITextView!
    @IBOutlet weak var switchImage: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var waitNotification: UITextView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let grayColor: UIColor = UIColor(netHex: 0x4d4d4d)
        
        self.nextButton.backgroundColor = colorKit.white
        self.nextButton.setTitleColor(grayColor, forState: UIControlState.Normal)
        self.nextButton.layer.cornerRadius = 20.0
        self.view.backgroundColor = grayColor
        
        self.view.addSubview(nextButton)
        self.view.addSubview(header)
        
        self.constrainButton(nextButton)
        self.constrainHeader(header)
        self.view.layoutSubviews()
        
        self.waitNotification.frame.origin.y = self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 10
    }
    
    @IBAction func nextStep(sender: UIButton) {
        delegate.finishTutorial()
    }
    
    func initialize() {
    }
}
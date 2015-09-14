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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let grayColor: UIColor = UIColor(netHex: 0x4d4d4d)
        
        self.nextButton.backgroundColor = colorKit.white
        self.nextButton.setTitleColor(grayColor, forState: UIControlState.Normal)
        self.nextButton.layer.cornerRadius = 20.0
        self.view.backgroundColor = grayColor
        
        let imageCeiling = header.frame.origin.y + header.frame.size.height
        let imageFloor = buttonLabel.frame.origin.y
        //let imagePosY = imageCeiling + (imageFloor - imageCeiling / 2.0) - (self.switchImage.frame.size.height / 2.0)
        
        //self.switchImage.frame = CGRectMake(switchImage.frame.origin.x, imagePosY, switchImage.frame.size.width, switchImage.frame.size.height)
    }
    
    @IBAction func nextStep(sender: UIButton) {
        delegate.finishTutorial()
    }
    
    func initialize() {
    }
}
//
//  TutorialStepZero.swift
//  AdShield
//
//  Created by Jae Lee on 9/1/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialStepZero: TutorialStep
{
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stepZeroHeader: UITextView!
    @IBOutlet weak var stepZeroSubheader: UITextView!
    @IBOutlet weak var stepZeroHeaderImage: UIImageView!
    
    var overlaySoft: UIView = UIView()
    var overlayHard: UIView = UIView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nextButton = self.primaryButtonStyle(nextButton)
        stepZeroHeaderImage.alpha = 0
        stepZeroSubheader = self.paragraphStyle(stepZeroSubheader)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
    }
    
    func initialize() {
        
        let translationDistance: CGFloat = 100.0
        
        let headerFrame = self.stepZeroHeader.frame
        self.stepZeroSubheader.frame.origin.y = headerFrame.origin.y + headerFrame.size.height
        let inset: CGFloat = 25.0
        let distanceFromToBeLogoToTop = self.logoImage.frame.origin.y - translationDistance
        self.stepZeroHeaderImage.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 0)
        self.stepZeroHeaderImage.alpha = 0.15
        
        UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseInOut, animations: {
            // LOGO MOVING
            let currentPosY = self.logoImage.frame.origin.y
            self.logoImage.frame.origin.y = currentPosY - translationDistance
            
            
            self.stepZeroHeaderImage.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, distanceFromToBeLogoToTop + inset)
            
            }, completion: {(Bool) in
                // LOGO MOVED
                
                UIView.animateWithDuration(0.7, animations: {
                    self.stepZeroHeader.alpha = 1.0
                    }, completion: {(Bool) in
                        let line = UIView()
                        line.backgroundColor = UIColor.grayColor()
                        
                        let subheaderFrame = self.stepZeroSubheader.frame
                        line.frame = CGRectMake(subheaderFrame.origin.y, subheaderFrame.origin.y, 100, 10)
                })
                
                self.delay(1.0) {
                    UIView.animateWithDuration(0.7, animations: {
                        self.nextButton.alpha = 1.0
                        self.stepZeroSubheader.alpha = 1.0
                    })
                }
        })
    }
}

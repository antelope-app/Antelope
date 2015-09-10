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
    
    @IBOutlet weak var barTwo: UIView!
    @IBOutlet weak var barOne: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let buttonOptions: [ String: String ] = [ "color": "teal" ]
        nextButton = self.borderButtonStyle(nextButton, options: buttonOptions)
        //stepZeroHeaderImage.alpha = 0
        stepZeroSubheader = self.paragraphStyle(stepZeroSubheader)
        
        barOne.hidden = true
        barTwo.hidden = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        
    }
    @IBAction func nextStep(sender: UIButton) {
        delegate.nextStep(0)
    }
    
    func initialize() {
        barOne.frame = CGRectMake(barOne.frame.origin.x, barOne.frame.origin.y, 0, 2)
        barOne.backgroundColor = colorKit.veryLightGrey
        barOne.hidden = false
        barTwo.frame = CGRectMake(barTwo.frame.origin.x, barTwo.frame.origin.y, 0, 2)
        barTwo.backgroundColor = colorKit.veryLightGrey
        barTwo.hidden = false
        
        let translationDistance: CGFloat = 140.0
        
        let headerFrame = self.stepZeroHeader.frame
        self.stepZeroSubheader.frame.origin.y = headerFrame.origin.y + headerFrame.size.height
        let inset: CGFloat = 25.0
        let distanceFromToBeLogoToTop = self.logoImage.frame.origin.y - translationDistance
        //self.stepZeroHeaderImage.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 0)
        //self.stepZeroHeaderImage.alpha = 0.15
        
        UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseInOut, animations: {
            // LOGO MOVING
            let currentPosY = self.logoImage.frame.origin.y
            self.logoImage.frame.origin.y = currentPosY - translationDistance
            
            
            //self.stepZeroHeaderImage.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, distanceFromToBeLogoToTop + inset)
            
            }, completion: {(Bool) in
                // LOGO MOVED
                
                UIView.animateWithDuration(0.7, animations: {
                    self.stepZeroHeader.alpha = 1.0
                    
                    }, completion: {(Bool) in
                })
                
                // sub header, then bars
                self.delay(1.0) {
                    UIView.animateWithDuration(0.7, animations: {
                        self.nextButton.alpha = 1.0
                        self.stepZeroSubheader.alpha = 1.0
                        
                    })
                }
        })
    }
}

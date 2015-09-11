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
    @IBOutlet weak var secondSubHeader: UITextView!
    @IBOutlet weak var thirdSubHeader: UITextView!
    
    var overlaySoft: UIView = UIView()
    var overlayHard: UIView = UIView()
    
    @IBOutlet weak var barTwo: UIView!
    @IBOutlet weak var barOne: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonOptions: [ String: String ] = [ "color": "teal" ]
        nextButton = self.borderButtonStyle(nextButton, options: buttonOptions)
        stepZeroSubheader = self.paragraphStyle(stepZeroSubheader)
        
        secondSubHeader.hidden = true
        secondSubHeader.text = "You'll use less data, see way fewer ads, have better battery life, and stop being tracked on the web."
        secondSubHeader = self.paragraphStyle(secondSubHeader)
        
        thirdSubHeader.hidden = true
        thirdSubHeader.text = "Antelope receives none of your browsing data, and it's entirely open-source."
        thirdSubHeader = self.paragraphStyle(thirdSubHeader)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    @IBAction func nextStep(sender: UIButton) {
        delegate.nextStep(0)
    }
    
    func initialize() {
        
        let translationDistance: CGFloat = 140.0
        
        let headerFrame = self.stepZeroHeader.frame
        self.stepZeroSubheader.frame.origin.y = headerFrame.origin.y + headerFrame.size.height
        
        self.secondSubHeader.frame = stepZeroSubheader.frame
        self.secondSubHeader.frame.origin.x = self.view.frame.size.width
        self.secondSubHeader.hidden = false
        
        self.delay(5.0, closure: {
            UIView.animateWithDuration(0.5, animations: {
                let anchor = self.stepZeroSubheader.frame.origin.x
                self.stepZeroSubheader.frame.origin.x = 0 - self.stepZeroSubheader.frame.size.width
                self.secondSubHeader.frame.origin.x = anchor
            })
        })
        
        self.thirdSubHeader.frame = self.secondSubHeader.frame
        self.thirdSubHeader.frame.origin.x = self.view.frame.size.width
        self.thirdSubHeader.hidden = false
        
        self.delay(10.0, closure: {
            UIView.animateWithDuration(0.5, animations: {
                let anchor = self.secondSubHeader.frame.origin.x
                self.secondSubHeader.frame.origin.x = 0 - self.secondSubHeader.frame.size.width
                self.thirdSubHeader.frame.origin.x = anchor
            })
        })
        
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

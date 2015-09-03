//
//  TutorialViewController.swift
//  AdShield
//
//  Created by Jae Lee on 8/31/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialViewController: ScrollViewController, TutorialStepDelegate {
    @IBOutlet weak var tutorialSplash: UIView!
    
    var absoluteStep: NSInteger = 0
    var step: NSInteger!
    
    var tutorialStepZero: TutorialStep!
    var tutorialStepOne: UIViewController = UIViewController()
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("tutorial view controller view did load")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tutorialStepZero = storyboard.instantiateViewControllerWithIdentifier("TutorialStepZero") as? TutorialStep
        tutorialStepZero.delegate = self
        
        //tutorialStepZero.view.backgroundColor = UIColor.blueColor()
        //tutorialStepOne.view.backgroundColor = UIColor.greenColor()
        
        viewControllersForSteps = [tutorialStepZero, tutorialStepOne]
        
        self.addChildViewControllers(viewControllersForSteps)
        
        // START TUTORIAL
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "startTutorial", userInfo: nil, repeats: false)
        
    }
    
    func nextStep()
    {
        print("SUCCESS")
        self.absoluteStep++
        self.scrollToViewControllerAtIndex(self.absoluteStep)
    }
    
    func startTutorial()
    {
        handleTutorialStep(absoluteStep)
    }
    
    override func scrollToViewControllerAtIndex(index: NSInteger) {
        super.scrollToViewControllerAtIndex(index)
        
        print("controller count ", self.childViewControllers.count)
    }
    
    func handleTutorialStep(index: NSInteger)
    {
        
        let stepZero = self.tutorialStepZero
        let translationDistance: CGFloat = 100.0
        
        let headerFrame = stepZero.stepZeroHeader.frame
        stepZero.stepZeroSubheader.frame.origin.y = headerFrame.origin.y + headerFrame.size.height
        let inset: CGFloat = 25.0
        let distanceFromToBeLogoToTop = stepZero.logoImage.frame.origin.y - translationDistance
        stepZero.stepZeroHeaderImage.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 0)
        stepZero.stepZeroHeaderImage.alpha = 0.15
        
        UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseInOut, animations: {
            // LOGO MOVING
            let currentPosY = stepZero.logoImage.frame.origin.y
            stepZero.logoImage.frame.origin.y = currentPosY - translationDistance
            
            
            stepZero.stepZeroHeaderImage.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, distanceFromToBeLogoToTop + inset)
            
            }, completion: {(Bool) in
                // LOGO MOVED
                
                UIView.animateWithDuration(0.7, animations: {
                    stepZero.stepZeroHeader.alpha = 1.0
                }, completion: {(Bool) in
                        var line = UIView()
                        line.backgroundColor = UIColor.grayColor()

                        let subheaderFrame = stepZero.stepZeroSubheader.frame
                        line.frame = CGRectMake(subheaderFrame.origin.y, subheaderFrame.origin.y, 100, 10)
                    })
                
                self.delay(1.0) {
                    UIView.animateWithDuration(0.7, animations: {
                        stepZero.nextButton.alpha = 1.0
                        stepZero.stepZeroSubheader.alpha = 1.0
                    })
                }
        })
        
        
    }
    
    func delay(delay:Double, closure:()->())
    {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

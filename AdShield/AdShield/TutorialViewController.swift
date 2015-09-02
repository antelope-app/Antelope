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
        UIView.animateWithDuration(0.7, animations: {
            let currentPosY = stepZero.logoImage.frame.origin.y
            
            stepZero.logoImage.frame.origin.y = currentPosY - 100
            }, completion: {(Bool) in
                
        })
        
        let headerFrame = stepZero.stepZeroHeader.frame
        stepZero.stepZeroSubheader.frame.origin.y = headerFrame.origin.y + headerFrame.size.height
        self.delay(0.5) {
            UIView.animateWithDuration(0.7, animations: {
                stepZero.nextButton.alpha = 1.0
                stepZero.stepZeroHeader.alpha = 1.0
                stepZero.stepZeroSubheader.alpha = 1.0
            })
        }
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

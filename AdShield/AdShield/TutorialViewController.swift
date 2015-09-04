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
    
    var tutorialStepZero: TutorialStepZero!
    var tutorialStepOne: TutorialStepOne!
    var tutorialStepTwo: TutorialStepTwo!
    var tutorialStepThree: TutorialStepThree!
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tutorialStepZero = storyboard.instantiateViewControllerWithIdentifier("TutorialStepZero") as? TutorialStepZero
        tutorialStepZero.delegate = self
        
        tutorialStepOne = storyboard.instantiateViewControllerWithIdentifier("TutorialStepOne") as? TutorialStepOne
        tutorialStepOne.delegate = self
        
        tutorialStepTwo = storyboard.instantiateViewControllerWithIdentifier("TutorialStepTwo") as? TutorialStepTwo
        tutorialStepTwo.delegate = self
        
        tutorialStepThree = storyboard.instantiateViewControllerWithIdentifier("TutorialStepThree") as? TutorialStepThree
        tutorialStepThree.delegate = self
        
        viewControllersForSteps = [tutorialStepZero, tutorialStepOne, tutorialStepTwo, tutorialStepThree]
        
        self.addChildViewControllers(viewControllersForSteps)
        
        // START TUTORIAL
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startTutorial", userInfo: nil, repeats: false)
        
    }
    
    func nextStep(index: NSInteger)
    {
        
        if self.absoluteStep < self.childViewControllers.count - 1 {
            self.absoluteStep++
        }
        self.scrollToViewControllerAtIndex(index + 1)
    }
    
    func startTutorial()
    {
        self.tutorialStepZero.initialize()
    }
    
    func finishTutorial() {
        print("done :)")
    }
    
    override func scrollToViewControllerAtIndex(index: NSInteger) {
        super.scrollToViewControllerAtIndex(index)
    }
    
}

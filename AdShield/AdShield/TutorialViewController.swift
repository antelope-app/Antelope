//
//  TutorialViewController.swift
//  AdShield
//
//  Created by Jae Lee on 8/31/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialViewController: ScrollViewController {
    @IBOutlet weak var tutorialSplash: UIView!
    
    var absoluteStep: NSInteger = 0
    var step: NSInteger!
    
    var tutorialStepZero: TutorialStepZero!
    var tutorialStepOne: TutorialStepOne!
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("tutorial view controller view did load")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tutorialStepZero = storyboard.instantiateViewControllerWithIdentifier("TutorialStepZero") as? TutorialStepZero
        
        tutorialStepOne = storyboard.instantiateViewControllerWithIdentifier("TutorialStepOne") as? TutorialStepOne
        
        //tutorialStepZero.view.backgroundColor = UIColor.blueColor()
        //tutorialStepOne.view.backgroundColor = UIColor.greenColor()
        
        viewControllersForSteps = [tutorialStepZero, tutorialStepOne]
        
        self.addChildViewControllers(viewControllersForSteps)
        
        // START TUTORIAL
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startTutorial", userInfo: nil, repeats: false)
        
    }
    
    func nextStep()
    {
        print("SUCCESS")
        self.absoluteStep++
        self.scrollToViewControllerAtIndex(self.absoluteStep)
    }
    
    func startTutorial()
    {
        self.tutorialStepZero.initialize()
    }
    
    override func scrollToViewControllerAtIndex(index: NSInteger) {
        super.scrollToViewControllerAtIndex(index)
        
        print("controller count \(self.childViewControllers.count)")
    }
    
    func handleTutorialStep(index: NSInteger)
    {
        
        
        
    }
}

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
    
    var tutorialStepZero: TutorialStep!
    var tutorialStepOne: UIViewController = UIViewController()
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tutorial view controller view did load")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tutorialStepZero = storyboard.instantiateViewControllerWithIdentifier("TutorialStepZero") as? TutorialStep
        
        tutorialStepZero.view.backgroundColor = UIColor.blueColor()
        tutorialStepOne.view.backgroundColor = UIColor.greenColor()
        
        viewControllersForSteps = [tutorialStepZero, tutorialStepOne]
        
        self.addChildViewControllers(viewControllersForSteps)
        
    }
    
    func startTutorial() {
        handleInterfaceForStep(absoluteStep)
    }
    
    override func scrollToViewControllerAtIndex(index: NSInteger) {
        super.scrollToViewControllerAtIndex(index)
        
        print("controller count ", self.childViewControllers.count)
    }
    
    func handleInterfaceForStep(index: NSInteger) {
        
    }
}

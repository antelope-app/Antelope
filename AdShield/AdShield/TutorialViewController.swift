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
    
    var absoluteStep: NSInteger!
    var step: NSInteger!
    
    var stepOneViewController: UIViewController = UIViewController()
    var stepTwoViewController: UIViewController = UIViewController()
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tutorial view controller view did load")
        
        stepOneViewController.view.backgroundColor = UIColor.blueColor()
        stepTwoViewController.view.backgroundColor = UIColor.greenColor()
        
        viewControllersForSteps = [stepOneViewController, stepTwoViewController]
        
        self.addChildViewControllers(viewControllersForSteps)
    }
    
    func handleInterfaceForStep(index: NSInteger) {
        
    }
    
    override func scrollToViewControllerAtIndex(index: NSInteger) {
        
    }
    
    func startTutorial() {
        
    }
}

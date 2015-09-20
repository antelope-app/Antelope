//
//  TutorialViewController.swift
//  Antelope
//
//  Created by Jae Lee on 8/31/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit

class TutorialViewController: ScrollViewController, TutorialStepDelegate, ShareViewDelegate {
    @IBOutlet weak var tutorialSplash: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var colorKit = AntelopeColors()
    
    var absoluteStep: NSInteger = 0
    var step: NSInteger!
    
    var tutorialStepZero: TutorialStepZero!
    var tutorialStepOne: TutorialStepOne!
    var tutorialStepTwo: TutorialStepTwo!
    var tutorialStepFour: TutorialStepFour!
    var tutorialStepThree: TutorialStepThree!
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.scrollView.delegate = self
        
        tutorialStepZero = storyboard.instantiateViewControllerWithIdentifier("TutorialStepZero") as? TutorialStepZero
        tutorialStepZero.delegate = self
        
        tutorialStepOne = storyboard.instantiateViewControllerWithIdentifier("TutorialStepOne") as? TutorialStepOne
        tutorialStepOne.delegate = self
        
        tutorialStepTwo = storyboard.instantiateViewControllerWithIdentifier("TutorialStepTwo") as? TutorialStepTwo
        tutorialStepTwo.delegate = self
        
        tutorialStepFour = storyboard.instantiateViewControllerWithIdentifier("TutorialStepFour") as? TutorialStepFour
        tutorialStepFour.delegate = self
        
        tutorialStepThree = storyboard.instantiateViewControllerWithIdentifier("TutorialStepThree") as? TutorialStepThree
        tutorialStepThree.delegate = self
        
        let shareViewController = ShareViewController()
        shareViewController.delegate = self
        
        viewControllersForSteps = [tutorialStepZero, tutorialStepOne, tutorialStepTwo, tutorialStepFour, tutorialStepThree, shareViewController]
        self.pageControl.numberOfPages = Int(viewControllersForSteps.count) - 1
        
        self.addChildViewControllers(viewControllersForSteps)
        
        // START TUTORIAL
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startTutorial", userInfo: nil, repeats: false)
        
    }
    
    func nextStep(index: NSInteger) {
        
        if self.absoluteStep < self.childViewControllers.count - 1 {
            self.absoluteStep++
        }
        self.scrollToViewControllerAtIndex(index + 1)
    }
    
    func startTutorial() {
        self.tutorialStepZero.initialize()
    }
    
    func restartTutorial() {
        self.scrollToViewControllerAtIndex(1)
    }
    
    func finishTutorial()
    {
        
        if let settingsURL: NSURL = NSURL(string: "prefs:root") {
            let application: UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(settingsURL)) {
                application.openURL(settingsURL)
            }
        }
        
        self.tutorialStepZero.delay(1.0, closure: {
            self.scrollToViewControllerAtIndex(Int(self.childViewControllers.count) - 1)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let totalWidth: CGFloat = self.scrollView.frame.size.width
        let pageNumber: Int = Int(floor(self.scrollView.contentOffset.x - totalWidth/50) / totalWidth + 1)
        
        self.pageControl.currentPage = pageNumber
    }
    
    @IBAction func pageChanged(sender: AnyObject) {
        let pageNumber: Int = self.pageControl.currentPage
        self.scrollToViewControllerAtIndex(pageNumber)
    }
    
    override func scrollToViewControllerAtIndex(index: NSInteger) {
        super.scrollToViewControllerAtIndex(index)
    }
    
}

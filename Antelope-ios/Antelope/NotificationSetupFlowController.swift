//
//  NotificationsSetupFlowController.swift
//  Antelope
//
//  Created by Jae Lee on 10/25/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation

protocol NotificationSetupFlowDelegate {
    func notificationSetupDidFinish()
}

class NotificationSetupFlowController: ScrollViewController, TutorialStepDelegate {
    
    var delegate: NotificationSetupFlowDelegate!
    var pageControl: UIPageControl!
    
    var colorKit = AntelopeColors()
    
    var absoluteStep: NSInteger = 0
    var step: NSInteger!
    
    var preNotificationPrompt = UIViewController()
    
    var tutorialStepZero: TutorialStepZero!
    var tutorialStepOne: TutorialStepOne!
    var tutorialStepTwo: TutorialStepTwo!
    var tutorialStepFour: TutorialStepFour!
    var tutorialStepThree: TutorialStepThree!
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.scrollView.delegate = self
        
        tutorialStepZero = storyboard.instantiateViewControllerWithIdentifier("TutorialStepZero") as? TutorialStepZero
        tutorialStepZero.delegate = self
        
        tutorialStepOne = storyboard.instantiateViewControllerWithIdentifier("TutorialStepOne") as? TutorialStepOne
        tutorialStepOne.delegate = self
        
        viewControllersForSteps = [tutorialStepZero, tutorialStepOne]
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = Int(viewControllersForSteps.count)
        pageControl.center.x = self.view.center.x
        pageControl.frame.origin.y = self.view.frame.size.height - 20
        
        self.addChildViewControllers(viewControllersForSteps)
        self.view.addSubview(pageControl)
        self.view.bringSubviewToFront(pageControl)
        
        // START TUTORIAL, self-invoking
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startTutorial", userInfo: nil, repeats: false)
        
    }
    
    func nextStep(index: NSInteger) {
        
        if index == self.childViewControllers.count - 1 {
            
            let shareHeader: UITextView = UITextView()
            shareHeader.frame.size = CGSizeMake(280, 120)
            shareHeader.center.x = self.view.center.x
            shareHeader.center.y = self.view.center.y - 80
            
            shareHeader.text = "Please allow push notifications! We need them on for the app to update properly"
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 12
            let headerAttributes = [NSParagraphStyleAttributeName: style, NSFontAttributeName: UIFont.systemFontOfSize(18.0)]
            shareHeader.attributedText = NSAttributedString(string: shareHeader.text, attributes: headerAttributes)
            shareHeader.textColor = colorKit.teal
            shareHeader.textAlignment = NSTextAlignment.Center
            shareHeader.userInteractionEnabled = false
            self.preNotificationPrompt.view.addSubview(shareHeader)
            
            var redoButton: UIButton = UIButton()
            redoButton.setTitle("OKAY", forState: UIControlState.Normal)
            redoButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
            let tutorialStep = TutorialStep()
            redoButton = tutorialStep.borderButtonStyle(redoButton, options: [ "color" : "teal" ])
            
            redoButton.frame.size = CGSizeMake(200, 40)
            redoButton.center.x = self.view.center.x
            redoButton.center.y = self.view.center.y + 40
            redoButton.addTarget(self, action: "finishTutorial", forControlEvents: .TouchUpInside)
            
            self.preNotificationPrompt.view.addSubview(redoButton)
            self.preNotificationPrompt.view.backgroundColor = colorKit.white

            self.presentViewController(preNotificationPrompt, animated: true, completion: {
                
            })
        } else {
            self.scrollToViewControllerAtIndex(index + 1)
        }
    }
    
    func startTutorial() {
        self.tutorialStepZero.initialize()
    }
    
    func restartTutorial() {
        self.scrollToViewControllerAtIndex(1)
    }
    
    func finishTutorial() {
        
        delegate.notificationSetupDidFinish()
        
        /*if let settingsURL: NSURL = NSURL(string: "prefs:root") {
        let application: UIApplication = UIApplication.sharedApplication()
        if (application.canOpenURL(settingsURL)) {
        application.openURL(settingsURL)
        }
        }
        
        self.tutorialStepZero.delay(1.0, closure: {
        self.scrollToViewControllerAtIndex(Int(self.childViewControllers.count) - 1)
        })*/
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scroll did in notification setup flow did scroll")
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

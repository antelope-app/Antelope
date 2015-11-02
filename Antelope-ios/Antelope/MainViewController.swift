//
//  ViewController.swift
//  Antelope
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit

protocol MainControllerDelegate {
    func didShareWithSuccess()
}

class MainViewController: UIViewController, TutorialFlowDelegate, TrialStateViewControllerDelegate, ShareFlowDelegate {
    var delegate: MainControllerDelegate!
    
    @IBOutlet weak var splashView: UIView!
    var tutorialViewController: TutorialViewController!
    var notificationSetupFlowController: NotificationSetupFlowController!
    var hasLaunchedOnce: Bool!
    var currentDate = NSDate()
        
    var app: UIApplication = UIApplication.sharedApplication()
    
    var shareViewController: ShareViewController!
    var trialStateViewController: TrialStateViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("main controller view did load")
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(self.splashView)
        self.splashView.backgroundColor = UIColor.whiteColor()
    }
    
    func showShareWall() {
        if self.shareViewController == nil {
            self.shareViewController = ShareViewController()
        }
        
        if self.presentedViewController != nil && self.presentedViewController != self.shareViewController {
            self.presentedViewController!.dismissViewControllerAnimated(true, completion: {
                self.presentViewController(self.shareViewController, animated: true, completion: nil)
            })
        } else {
            if self.presentedViewController == nil {
                self.presentViewController(self.shareViewController, animated: true, completion: nil)
            }
        }
        
        if self.shareViewController.delegate == nil {
            self.shareViewController.delegate = self
        }
        
    }
    
    func trialStateActive() {
        self.trialStateViewController = TrialStateViewController()
        self.trialStateViewController.delegate = self
        self.addChildViewController(trialStateViewController)
        
        if (self.tutorialViewController != nil) {
            self.view.insertSubview(trialStateViewController.view, belowSubview: self.tutorialViewController.view)
        } else {
            self.view.addSubview(trialStateViewController.view)
        }
    }
    
    func startNotificationSetup() {
        self.notificationSetupFlowController = NotificationSetupFlowController()
        
        self.addChildViewController(self.notificationSetupFlowController)
        self.view.insertSubview(self.notificationSetupFlowController.view, aboveSubview: self.splashView)
    }
    
    func segueToTutorial(completionHandler: () -> Void) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if self.tutorialViewController == nil {
            tutorialViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialViewController") as? TutorialViewController
        }
        tutorialViewController.segueFromNotificationSetupFlow = true
        
        if self.presentedViewController != nil {
            self.presentedViewController?.dismissViewControllerAnimated(true, completion: {
                self.presentViewController(self.tutorialViewController, animated: true, completion: completionHandler)
                self.tutorialViewController.delegate = self
            })
        } else {
            self.presentViewController(tutorialViewController, animated: true, completion: completionHandler)
            tutorialViewController.delegate = self
        }

    }
    
    func startTutorial() {
        print("starting tutorial")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tutorialViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialViewController") as? TutorialViewController
        tutorialViewController.delegate = self
        
        self.addChildViewController(tutorialViewController)
        
        tutorialViewController.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(tutorialViewController.view)
    }
    
    func restartTutorial() {
        self.segueToTutorial({
            
        })
    }
    
    func tutorialDidFinish() {
        print("handling tutorial finish")
        
        if self.trialStateViewController == nil {
            self.trialStateViewController = TrialStateViewController()
            self.trialStateViewController.delegate = self
            self.addChildViewController(self.trialStateViewController)
            self.view.insertSubview(self.trialStateViewController.view, belowSubview: self.tutorialViewController.view)
        }
        
        if self.presentedViewController != nil && self.tutorialViewController != nil && self.presentedViewController == self.tutorialViewController {
            print("is modal")
            self.tutorialViewController.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("is not modal")
            UIView.animateWithDuration(0.3, animations: {
                self.tutorialViewController.view.frame.origin.y = self.view.frame.size.height
                self.tutorialViewController = nil
            })
        }
    }
    
    func didShareWithSuccess() {
        print("delegate callback in mainview did share with success")
        delegate.didShareWithSuccess()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


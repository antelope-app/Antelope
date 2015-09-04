//
//  ScrollViewController.swift
//  AdShield
//
//  Created by Jae Lee on 8/30/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    var placementOffset: CGFloat = 0.0
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)
        
        scrollView = UIScrollView.init(frame: self.view.frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        
        scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height)
        scrollView.bounces = false
        
        self.view.addSubview(scrollView)
        
    }
    
    func scrollToViewControllerAtIndex(index: NSInteger) {
        if self.childViewControllers.count >= index {
            let viewController: UIViewController = self.childViewControllers[index]
            self.scrollToViewController(viewController)
        }
    }

    
    func scrollToViewController(viewController: UIViewController) {
        print("scrolling to controller")
        for childViewController in self.childViewControllers {
            if childViewController === viewController {
                self.scrollView.scrollRectToVisible(childViewController.view.frame, animated: true)
            }
        }
    }
    
    func addChildViewControllers(viewControllers: [UIViewController]) {
        for viewController in viewControllers as [UIViewController] {
            self.addChildViewController(viewController)
        }
    }
    
    override func addChildViewController(childController: UIViewController) {
        super.addChildViewController(childController)
        
        let childView: UIView = childController.view
        let childViewSize: CGSize = childView.frame.size
        let scrollViewContentSize = self.scrollView.contentSize
        
        childView.frame = CGRectMake(self.placementOffset, 0, childViewSize.width, scrollViewContentSize.height)
        self.scrollView.contentSize = CGSizeMake(childViewSize.width + scrollViewContentSize.width, scrollViewContentSize.height)
        self.placementOffset += childView.frame.size.width
        
        self.scrollView.addSubview(childView)
        
    }
    
}
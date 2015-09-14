//
//  ScrollViewController.h
//  Spark
//
//  Created by Adam Gluck on 3/8/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController

- (void)addChildViewControllers:(NSArray *)viewControllers;
- (void)scrollToViewController:(UIViewController *)viewController;
- (void)scrollToViewControllerAtIndex:(NSUInteger)index;

@end

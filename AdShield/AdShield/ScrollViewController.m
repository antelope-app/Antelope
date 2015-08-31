//
//  ScrollViewController.m
//  Spark
//
//  Created by Adam Gluck on 3/8/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) CGFloat placementOffset;

@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height);
        scrollView.bounces = NO;
        scrollView;
    });
    
    [self.view addSubview:self.scrollView];
    
    self.placementOffset = 0.0f;
}

#pragma mark - Scrolling

- (void)scrollToViewControllerAtIndex:(NSUInteger)index
{
    if ([self.childViewControllers count] <= index) {
        UIViewController *viewController = self.childViewControllers[index];
        [self scrollToViewController:viewController];
    }
}

- (void)scrollToViewController:(UIViewController *)viewController
{
    for (UIViewController *childViewController in self.childViewControllers) {
        if ([childViewController isEqual:viewController]) {
            [self.scrollView scrollRectToVisible:childViewController.view.frame animated:YES];
            break;
        }
    }
}

- (void)addChildViewControllers:(NSArray *)viewControllers
{
    for (UIViewController *viewController in viewControllers) {
        [self addChildViewController:viewController];
    }
}

#pragma mark - Overrides

- (void)addChildViewController:(UIViewController *)childController
{
    [super addChildViewController:childController];
    
    UIView *childView = childController.view;
    CGSize childViewSize = childView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    childView.frame = CGRectMake(self.placementOffset, 0, childViewSize.width, childViewSize.height);
    self.scrollView.contentSize = CGSizeMake(childViewSize.width + scrollViewContentSize.width, scrollViewContentSize.height);
    
    self.placementOffset += childView.frame.size.width;
    
    [self.scrollView addSubview:childView];
}

@end

//
//  ACTemplatePVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 03/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplatePVC.h"

#pragma mark - ACTemplatePageVC
@implementation ACTemplatePageVC
@end

#pragma mark - ACTemplatePVC
@interface ACTemplatePVC ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@end

@implementation ACTemplatePVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.view.frame = self.view.frame;
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    if (self.ac_delegate && [self.ac_delegate respondsToSelector:@selector(ac_templatePVC:viewControllerForPage:)]) {
        [self.pageViewController setViewControllers:@[[self.ac_delegate ac_templatePVC:self viewControllerForPage:0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
    }
}

#pragma mark UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = ((ACTemplatePageVC *) viewController).index;
    if ((index == 0) || !self.ac_delegate || ![self.ac_delegate respondsToSelector:@selector(ac_templatePVC:viewControllerForPage:)]) {
        return nil;
    }
    
    return [self.ac_delegate ac_templatePVC:self viewControllerForPage:--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = ((ACTemplatePageVC *) viewController).index;
    if (!self.ac_delegate || ![self.ac_delegate respondsToSelector:@selector(ac_numberOfPagesInTemplatePVC:)] || (index == (INFINITE_NUMBER_OF_PAGES - 1)) ||
        ![self.ac_delegate respondsToSelector:@selector(ac_templatePVC:viewControllerForPage:)]) {
        return nil;
    }
    
    return [self.ac_delegate ac_templatePVC:self viewControllerForPage:++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (self.ac_delegate && [self.ac_delegate respondsToSelector:@selector(ac_templatePVC:pageDidAppear:)]) {
        [self.ac_delegate ac_templatePVC:self pageDidAppear:pageViewController.viewControllers.lastObject];
    }
}

@end

//
//  UIViewController+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(AppCore)
+ (UIViewController *)ac_findBestViewController:(UIViewController *)vc;
+ (UIViewController *)ac_currentViewController;

+ (instancetype)ac_newInstance;

- (void)ac_initBackButtonIfNeeded;

- (CGRect)ac_visibleFrame;

- (UIBarButtonItem *)ac_backButton;
- (void)ac_onBackButtonTouch:(UIBarButtonItem *)sender;
- (void)ac_removeBackButton;

- (void)ac_startLoadingProcess;
- (void)ac_stopLoadingProcess;
- (BOOL)ac_isNowLoading;

- (void)ac_hideKeyboard;

- (UINavigationController *)ac_embedInNavigationController;

// Add Child View Controller
- (void)ac_addChildViewController:(UIViewController *)childViewController
                intoViewContainer:(UIView *)viewContainer;
- (void)ac_addChildViewController:(UIViewController *)childViewController;
- (void)ac_removeChildViewController:(UIViewController *)childViewController;
@end

Class ACVCClassFromParentVCClass(Class parentVCClass);

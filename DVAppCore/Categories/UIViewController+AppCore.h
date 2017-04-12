//
//  UIViewController+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController(AppCore)
+ (UIViewController *)ac_findBestViewController:(UIViewController *)vc;
+ (UIViewController *)ac_currentViewController;

+ (instancetype)ac_newInstance;

- (BOOL)ac_isVisible;
- (BOOL)ac_isViewAppearNotFirstTime;
- (CGRect)ac_visibleFrame;

- (UIBarButtonItem *)ac_backButton;
- (void)ac_onBackButtonTouch:(UIBarButtonItem *)sender;
- (void)ac_removeBackButton;

- (void)ac_startLoadingProcess;
- (void)ac_stopLoadingProcess;
- (BOOL)ac_isNowLoading;

- (void)ac_hideKeyboard;

- (UINavigationController *)ac_embedInNavigationController;
@end

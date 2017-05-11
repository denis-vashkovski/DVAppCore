//
//  UINavigationController+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ACAnimationTransitionNone,
    ACAnimationTransitionFlipFromLeft,
    ACAnimationTransitionFlipFromRight,
    ACAnimationTransitionCurlUp,
    ACAnimationTransitionCurlDown,
    ACAnimationTransitionCrossDissolve,
    ACAnimationTransitionFlipFromTop,
    ACAnimationTransitionFlipFromBottom,
} ACAnimationTransition;

@interface UINavigationController(AppCore)
- (UIViewController *)ac_previousViewController;

#pragma mark - Push
- (void)ac_pushViewController:(UIViewController *)viewController
                animationType:(ACAnimationTransition)animationType
            animationDuration:(NSTimeInterval)animationDuration
            completionHandler:(void (^)())completionHandler;

- (void)ac_pushViewController:(UIViewController *)viewController
                animationType:(ACAnimationTransition)animationType;

#pragma mark - Pop
- (void)ac_popViewControllerAnimationType:(ACAnimationTransition)animationType
                        animationDuration:(NSTimeInterval)animationDuration
                        completionHandler:(void (^)())completionHandler;

- (void)ac_popViewControllerAnimationType:(ACAnimationTransition)animationType;

- (void)ac_popToRootViewControllerAnimationType:(ACAnimationTransition)animationType
                              animationDuration:(NSTimeInterval)animationDuration
                              completionHandler:(void (^)())completionHandler;

- (void)ac_popToRootViewControllerAnimationType:(ACAnimationTransition)animationType;

#pragma mark - Set
- (void)ac_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                animationType:(ACAnimationTransition)animationType
            animationDuration:(NSTimeInterval)animationDuration
            completionHandler:(void (^)())completionHandler;

- (void)ac_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                animationType:(ACAnimationTransition)animationType;
@end

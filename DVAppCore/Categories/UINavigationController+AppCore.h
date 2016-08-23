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

- (void)ac_pushViewController:(UIViewController *)viewController
                animationType:(ACAnimationTransition)animationType
            animationDuration:(NSTimeInterval)animationDuration
            completionHandler:(void (^)())completionHandler;
@end

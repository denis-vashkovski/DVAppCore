//
//  UINavigationController+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UINavigationController+AppCore.h"

#import "ACConstants.h"

@implementation UINavigationController(AppCore)

- (UIViewController *)ac_previousViewController {
    return (self.viewControllers.count < 2) ? nil : [self.viewControllers objectAtIndex:(self.viewControllers.count - 2)];
}

- (void)ac_pushViewController:(UIViewController *)viewController
                animationType:(ACAnimationTransition)animationType
            animationDuration:(NSTimeInterval)animationDuration
            completionHandler:(void (^)())completionHandler {
    if (!viewController) return;
    
    static NSDictionary *convertTransitionType;
    if (!convertTransitionType) {
        convertTransitionType = @{ @(ACAnimationTransitionNone):            @(UIViewAnimationOptionTransitionNone),
                                   @(ACAnimationTransitionFlipFromLeft):    @(UIViewAnimationOptionTransitionFlipFromLeft),
                                   @(ACAnimationTransitionFlipFromRight):   @(UIViewAnimationOptionTransitionFlipFromRight),
                                   @(ACAnimationTransitionCurlUp):          @(UIViewAnimationOptionTransitionCurlUp),
                                   @(ACAnimationTransitionCurlDown):        @(UIViewAnimationOptionTransitionCurlDown),
                                   @(ACAnimationTransitionCrossDissolve):   @(UIViewAnimationOptionTransitionCrossDissolve),
                                   @(ACAnimationTransitionFlipFromTop):     @(UIViewAnimationOptionTransitionFlipFromTop),
                                   @(ACAnimationTransitionFlipFromBottom):  @(UIViewAnimationOptionTransitionFlipFromBottom)};
    }
    
    [UIView transitionWithView:self.view
                      duration:animationDuration
                       options:(UIViewAnimationOptions)[convertTransitionType[@(animationType)] intValue]
                    animations:^{
                        if ([self.viewControllers containsObject:viewController]) {
                            [self popToViewController:viewController animated:NO];
                        } else {
                            [self pushViewController:viewController animated:NO];
                        }
                    }
                    completion:^(BOOL finished) {
                        if (completionHandler) {
                            completionHandler();
                        }
                    }];
}

- (void)ac_pushViewController:(UIViewController *)viewController animationType:(ACAnimationTransition)animationType {
    [self ac_pushViewController:viewController
                  animationType:animationType
              animationDuration:AC_ANIMATION_DURATION_DEFAULT
              completionHandler:nil];
}

- (void)ac_popViewControllerAnimationType:(ACAnimationTransition)animationType
                        animationDuration:(NSTimeInterval)animationDuration
                        completionHandler:(void (^)())completionHandler {
    if (self.viewControllers.count < 2) return;
    
    [self ac_pushViewController:self.viewControllers[self.viewControllers.count - 2]
                  animationType:animationType
              animationDuration:animationDuration
              completionHandler:completionHandler];
}

- (void)ac_popViewControllerAnimationType:(ACAnimationTransition)animationType {
    [self ac_popViewControllerAnimationType:animationType
                          animationDuration:AC_ANIMATION_DURATION_DEFAULT
                          completionHandler:nil];
}

@end

//
//  UINavigationController+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UINavigationController+AppCore.h"

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

@end

//
//  UINavigationController+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UINavigationController+AppCore.h"

#import "ACConstants.h"

#import "NSArray+AppCore.h"

typedef enum {
    ACTransitionTypePushOrPop,
    ACTransitionTypeSet
} ACTransitionType;

@implementation UINavigationController(AppCore)

- (UIViewController *)ac_previousViewController {
    return (self.viewControllers.count < 2) ? nil : [self.viewControllers objectAtIndex:(self.viewControllers.count - 2)];
}

#pragma mark - Push
- (void)ac_pushViewController:(UIViewController *)viewController
                animationType:(ACAnimationTransition)animationType
            animationDuration:(NSTimeInterval)animationDuration
            completionHandler:(void (^)(void))completionHandler {
    [self ac_setViewControllers:@[ viewController ]
                           type:ACTransitionTypePushOrPop
                  animationType:animationType
              animationDuration:animationDuration
              completionHandler:completionHandler];
}

- (void)ac_pushViewController:(UIViewController *)viewController animationType:(ACAnimationTransition)animationType {
    [self ac_pushViewController:viewController
                  animationType:animationType
              animationDuration:AC_ANIMATION_DURATION_DEFAULT
              completionHandler:nil];
}

#pragma mark - Pop
- (void)ac_popViewControllerAnimationType:(ACAnimationTransition)animationType
                        animationDuration:(NSTimeInterval)animationDuration
                        completionHandler:(void (^)(void))completionHandler {
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

- (void)ac_popToRootViewControllerAnimationType:(ACAnimationTransition)animationType
                              animationDuration:(NSTimeInterval)animationDuration
                              completionHandler:(void (^)(void))completionHandler {
    [self ac_pushViewController:self.viewControllers.firstObject animationType:animationType];
}

- (void)ac_popToRootViewControllerAnimationType:(ACAnimationTransition)animationType {
    [self ac_popToRootViewControllerAnimationType:animationType
                                animationDuration:AC_ANIMATION_DURATION_DEFAULT
                                completionHandler:nil];
}

#pragma mark - Set
- (void)ac_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                animationType:(ACAnimationTransition)animationType
            animationDuration:(NSTimeInterval)animationDuration
            completionHandler:(void (^)(void))completionHandler {
    [self ac_setViewControllers:viewControllers
                           type:ACTransitionTypeSet
                  animationType:animationType
              animationDuration:animationDuration
              completionHandler:completionHandler];
}

- (void)ac_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                animationType:(ACAnimationTransition)animationType {
    [self ac_setViewControllers:viewControllers
                  animationType:animationType
              animationDuration:AC_ANIMATION_DURATION_DEFAULT
              completionHandler:nil];
}

#pragma mark - Private
- (void)ac_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                         type:(ACTransitionType)type
                animationType:(ACAnimationTransition)animationType
            animationDuration:(NSTimeInterval)animationDuration
            completionHandler:(void (^)(void))completionHandler {
    if (!ACValidArray(viewControllers)) return;
    
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
                        switch (type) {
                            case ACTransitionTypeSet:{
                                [self setViewControllers:viewControllers animated:NO];
                                
                                break;
                            }
                            default:{
                                UIViewController *viewController = viewControllers.firstObject;
                                
                                if ([self.viewControllers containsObject:viewController]) {
                                    [self popToViewController:viewController animated:NO];
                                } else {
                                    [self pushViewController:viewController animated:NO];
                                }
                                
                                break;
                            }
                        }
                    }
                    completion:^(BOOL finished) {
                        if (completionHandler) {
                            completionHandler();
                        }
                    }];
}

@end

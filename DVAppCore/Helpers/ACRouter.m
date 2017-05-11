//
//  ACRouter.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACRouter.h"

@implementation ACRouter
ACSINGLETON_M

+ (UIStoryboard *)storyboardByName:(NSString *)storyboardName {
    if (![storyboardName hasSuffix:ACRouterStoryboardIPhoneSufix] &&
        ![storyboardName hasSuffix:ACRouterStoryboardIPadSufix]) {
        
        NSString *sufix = nil;
        switch ([UIDevice currentDevice].userInterfaceIdiom) {
            case UIUserInterfaceIdiomPhone:
                sufix = ACRouterStoryboardIPhoneSufix;
                break;
            case UIUserInterfaceIdiomPad:
                sufix = ACRouterStoryboardIPadSufix;
                break;
            default: break;
        }
        
        if (ACValidStr(sufix)) {
            storyboardName = [NSString stringWithFormat:@"%@_%@", storyboardName, sufix];
        }
    }
    return [UIStoryboard storyboardWithName:storyboardName bundle:nil];
}

+ (UIViewController *)getVCByName:(NSString *)vcName storyboardName:(NSString *)storyboardName {
    return [[self storyboardByName:storyboardName] instantiateViewControllerWithIdentifier:vcName];
}

+ (UIViewController *)getInitialVCByStoryboardName:(NSString *)storyboardName {
    return [[self storyboardByName:storyboardName] instantiateInitialViewController];
}

@end

AC_EXTERN_STRING_M_V(ACRouterStoryboardIPhoneSufix, @"iPhone")
AC_EXTERN_STRING_M_V(ACRouterStoryboardIPadSufix, @"iPad")

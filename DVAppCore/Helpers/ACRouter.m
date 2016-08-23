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
    return [UIStoryboard storyboardWithName:storyboardName bundle:nil];
}

+ (UIViewController *)getVCByName:(NSString *)vcName storyboardName:(NSString *)storyboardName {
    return [[self storyboardByName:storyboardName] instantiateViewControllerWithIdentifier:vcName];
}

+ (UIViewController *)getInitialVCByStoryboardName:(NSString *)storyboardName {
    return [[self storyboardByName:storyboardName] instantiateInitialViewController];
}

@end

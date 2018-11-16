//
//  UIWindow+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "UIWindow+AppCore.h"

@implementation UIWindow(AppCore)

+ (UIWindow *)ac_currentWindow {
    return [UIApplication sharedApplication].delegate.window;
}

+ (UIEdgeInsets)ac_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [self ac_currentWindow].safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

@end

//
//  UIWindow+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow(AppCore)
+ (UIWindow *)ac_currentWindow;
+ (UIEdgeInsets)ac_safeAreaInsets;
@end

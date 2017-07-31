//
//  UIBarButtonItem+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 08/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIBarButtonItem+AppCore.h"

#import "NSObject+AppCore.h"
#import "UIColor+AppCore.h"

#import "ACConstants.h"

@implementation UIBarButtonItem(AppCore)

+ (instancetype)ac_barButtonFixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *barButtonBetween = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil];
    [barButtonBetween setWidth:width];
    
    return barButtonBetween;
}

AC_CATEGORY_PROPERTY_GET_BOOL(ac_isHidden)
- (void)setAc_hidden:(BOOL)ac_hidden {
    objc_setAssociatedObject(self, @selector(ac_isHidden), [NSNumber numberWithBool:ac_hidden], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTintColor:(ac_hidden ? ACColorClear : nil)];
    [self setEnabled:!ac_hidden];
}

- (void)ac_setHidden:(BOOL)hidden animate:(BOOL)animate {
    [UIView animateWithDuration:(animate ? AC_ANIMATION_DURATION_DEFAULT : .0)
                     animations:^{
                         [self setAc_hidden:hidden];
                     }];
}

@end

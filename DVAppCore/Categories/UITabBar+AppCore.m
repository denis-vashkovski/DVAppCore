//
//  UITabBar+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITabBar+AppCore.h"

#import "ACConstants.h"

@implementation UITabBar(AppCore)

- (void)ac_hidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    if ([self ac_isVisible] == !hidden) return;
    
    CGRect frame = self.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = hidden ? height : -height;
    
    CGFloat duration = animated ? AC_ANIMATION_DURATION_DEFAULT : .0;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectOffset(frame, .0, offsetY);
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (BOOL)ac_isVisible {
    return CGRectGetMinY(self.frame) < CGRectGetMaxY(self.superview.frame);
}

@end

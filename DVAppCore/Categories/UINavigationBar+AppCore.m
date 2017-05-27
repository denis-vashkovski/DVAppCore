//
//  UINavigationBar+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/05/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import "UINavigationBar+AppCore.h"

#import "NSObject+AppCore.h"

@implementation UINavigationBar(AppCore)

- (UIView *)overlay {
    UIView *overlay = objc_getAssociatedObject(self, @selector(overlay));
    if (!overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, CGRectGetWidth(self.bounds), statusBarHeight)];
        overlay.userInteractionEnabled = NO;
        [self addSubview:overlay];
        
        [self setOverlay:overlay];
    }
    
    return overlay;
}

AC_CATEGORY_PROPERTY_SET(UIView *, overlay, setOverlay:)

- (void)ac_setBackgroundColor:(UIColor *)backgroundColor {
    self.overlay.backgroundColor = backgroundColor;
    [self setBackgroundColor:backgroundColor];
}

@end

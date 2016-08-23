//
//  UILabel+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UILabel+AppCore.h"

#import "NSObject+AppCore.h"

#import "UIView+AppCore.h"

@implementation UILabel(AppCore)

AC_LOAD_ONCE([self ac_addSwizzlingSelector:@selector(ac_drawTextInRect:) originalSelector:@selector(drawTextInRect:)];)

- (UIEdgeInsets)ac_textInsets {
    return UIEdgeInsetsFromString(objc_getAssociatedObject(self, @selector(ac_textInsets)));
}

- (void)setAc_textInsets:(UIEdgeInsets)ac_textInsets {
    objc_setAssociatedObject(self, @selector(ac_textInsets), NSStringFromUIEdgeInsets(ac_textInsets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ac_drawTextInRect:(CGRect)rect {
    [self ac_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.ac_textInsets)];
}

- (void)ac_setText:(NSString *)text animationDuration:(NSTimeInterval)duration {
    [self ac_addFadeAnimationWithDuration:duration];
    [self setText:text];
}

- (void)ac_setAttributedText:(NSAttributedString *)attributedText animationDuration:(NSTimeInterval)duration {
    [self ac_addFadeAnimationWithDuration:duration];
    [self setAttributedText:attributedText];
}

@end

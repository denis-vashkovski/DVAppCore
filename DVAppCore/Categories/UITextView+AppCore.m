//
//  UITextView+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITextView+AppCore.h"

#import "NSAttributedString+AppCore.h"
#import "NSString+AppCore.h"
#import "NSObject+AppCore.h"

#import "UIView+AppCore.h"

@implementation UITextView(AppCore)

AC_LOAD_ONCE([self ac_addSwizzlingSelector:@selector(ac_setContentSize:) originalSelector:@selector(setContentSize:)];)

CATEGORY_PROPERTY_GET_NSNUMBER_PRIMITIVE(ACContentVerticalAlignment, ac_contentVerticalAlignment, intValue);
- (void)setAc_contentVerticalAlignment:(ACContentVerticalAlignment)ac_contentVerticalAlignment {
    objc_setAssociatedObject(self,
                             @selector(ac_contentVerticalAlignment),
                             [NSNumber numberWithInt:ac_contentVerticalAlignment],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateContentPosition];
}

#define LABEL_PLACEHOLDER_TAG 9876
CATEGORY_PROPERTY_GET(NSAttributedString *, ac_placeholder)
- (void)setAc_placeholder:(NSAttributedString *)ac_placeholder {
    objc_setAssociatedObject(self, @selector(ac_placeholder), ac_placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *label = [self viewWithTag:LABEL_PLACEHOLDER_TAG];
    if (!label) {
        label = [UILabel new];
        [label setTag:LABEL_PLACEHOLDER_TAG];
        [label ac_setBackgroundClearColor];
        [self addSubview:label];
        
        [label ac_addConstraintsSuperviewWithInsets:self.ac_placeholderInsets];
    }
    
    [label setAttributedText:ac_placeholder];
}

- (UIEdgeInsets)ac_placeholderInsets {
    return UIEdgeInsetsFromString(objc_getAssociatedObject(self, @selector(ac_placeholderInsets)));
}

- (void)setAc_placeholderInsets:(UIEdgeInsets)ac_placeholderInsets {
    objc_setAssociatedObject(self, @selector(ac_placeholderInsets), NSStringFromUIEdgeInsets(ac_placeholderInsets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateContentPosition {
    CGFloat topCorrect = .0;
    float textHeight = .0;
    
    [self layoutIfNeeded];
    
    if (self.attributedText) {
        textHeight = [self.attributedText ac_heightForWidth:self.frame.size.width];
    } else if (self.text && !self.text.ac_isEmpty) {
        textHeight = [self.text ac_heightForFont:self.font andWidth:self.frame.size.width];
    }
    
    switch (self.ac_contentVerticalAlignment) {
        case ACContentVerticalAlignmentCenter:{
            topCorrect = ([self bounds].size.height - textHeight) / 2.;
            break;
        }
        case ACContentVerticalAlignmentBottom:{
            topCorrect = [self bounds].size.height - textHeight;
            break;
        }
        default:
            break;
    }
    
    [self setTextContainerInset:UIEdgeInsetsMake(MAX(ceilf(topCorrect), .0), .0, .0, .0)];
}

- (void)ac_setContentSize:(CGSize)contentSize {
    [self ac_setContentSize:contentSize];
    
#warning TODO fail test without comment
//    [self updateContentPosition];
}

- (void)ac_setText:(NSString *)text animationDuration:(NSTimeInterval)duration {
    [self ac_addFadeAnimationWithDuration:duration];
    [self setText:text];
}

- (void)ac_setAttributedText:(NSAttributedString *)attributedText animationDuration:(NSTimeInterval)duration {
    [self ac_addFadeAnimationWithDuration:duration];
    [self setAttributedText:attributedText];
}

- (void)ac_removeTextPadding {
    self.textContainer.lineFragmentPadding = 0.;
    self.textContainerInset = UIEdgeInsetsZero;
}

@end

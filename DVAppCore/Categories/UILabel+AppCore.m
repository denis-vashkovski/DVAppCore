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

- (void)ac_setText:(NSString *)text animationDuration:(NSTimeInterval)duration {
    [self ac_addFadeAnimationWithDuration:duration];
    [self setText:text];
}

- (void)ac_setAttributedText:(NSAttributedString *)attributedText animationDuration:(NSTimeInterval)duration {
    [self ac_addFadeAnimationWithDuration:duration];
    [self setAttributedText:attributedText];
}

@end

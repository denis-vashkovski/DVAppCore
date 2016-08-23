//
//  NSAttributedString+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSAttributedString+AppCore.h"

@implementation NSAttributedString(AppCore)

- (CGRect)attributedStringFrameBySize:(CGSize)size {
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                              context:nil];
}

- (CGFloat)ac_heightForWidth:(CGFloat)width {
    return CGRectGetHeight([self attributedStringFrameBySize:CGSizeMake(width, CGFLOAT_MAX)]);
}

- (CGFloat)ac_widthByMaxWidth:(CGFloat)maxWidth {
    return CGRectGetWidth([self attributedStringFrameBySize:CGSizeMake(maxWidth, CGFLOAT_MAX)]);
}

- (CGFloat)ac_width {
    return [self ac_widthByMaxWidth:CGFLOAT_MAX];
}

@end

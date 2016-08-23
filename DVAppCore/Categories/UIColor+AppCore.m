//
//  UIColor+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIColor+AppCore.h"

#import "NSString+AppCore.h"

@implementation UIColor(AppCore)

+ (UIColor *)ac_colorFromHexString:(NSString *)hexString alpha:(float)alpha {
    if (ValidStr(hexString)) {
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        
        if (scanner) {
            [scanner setScanLocation:([hexString ac_isContains:@"#"] ? 1 : 0)];
            
            unsigned rgbValue = 0;
            [scanner scanHexInt:&rgbValue];
            
            return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.
                                   green:((rgbValue & 0xFF00) >> 8) / 255.
                                    blue:(rgbValue & 0xFF) / 255.
                                   alpha:alpha];
        }
    }
    
    return nil;
}

+ (UIColor *)ac_colorFromHexString:(NSString *)hexString {
    return [self ac_colorFromHexString:hexString alpha:1.0f];
}

- (BOOL)ac_isEqualToColor:(UIColor *)color withTolerance:(CGFloat)tolerance {
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    return
    fabs(r1 - r2) <= tolerance &&
    fabs(g1 - g2) <= tolerance &&
    fabs(b1 - b2) <= tolerance &&
    fabs(a1 - a2) <= tolerance;
}

- (BOOL)ac_isEqualToColor:(UIColor *)color {
//    return CGColorEqualToColor(self.CGColor, color.CGColor);
    return [self ac_isEqualToColor:color withTolerance:.0];
}

- (CGFloat)ac_red {
    CGFloat red = .0f;
    [self getRed:&red green:nil blue:nil alpha:nil];
    return red;
}

- (CGFloat)ac_green {
    CGFloat green = .0f;
    [self getRed:nil green:&green blue:nil alpha:nil];
    return green;
}

- (CGFloat)ac_blue {
    CGFloat blue = .0f;
    [self getRed:nil green:nil blue:&blue alpha:nil];
    return blue;
}

- (CGFloat)ac_alpha {
    CGFloat alpha = .0f;
    [self getRed:nil green:nil blue:nil alpha:&alpha];
    return alpha;
}

@end

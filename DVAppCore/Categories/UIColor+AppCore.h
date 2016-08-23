//
//  UIColor+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(AppCore)
+ (UIColor *)ac_colorFromHexString:(NSString *)hexString alpha:(float)alpha;
+ (UIColor *)ac_colorFromHexString:(NSString *)hexString;

- (BOOL)ac_isEqualToColor:(UIColor *)color withTolerance:(CGFloat)tolerance;
- (BOOL)ac_isEqualToColor:(UIColor *)color;

- (CGFloat)ac_red;
- (CGFloat)ac_green;
- (CGFloat)ac_blue;
- (CGFloat)ac_alpha;
@end

#define ACColorHexA(hexStr, alphaValue) [UIColor ac_colorFromHexString:(hexStr) alpha:(alphaValue)]
#define ACColorHex(hexStr) ACColorHexA((hexStr), 1.f)

#define ACColorClear ACColorHexA(@"ffffff", .0)
#define ACColorWhite ACColorHex(@"ffffff")
#define ACColorBlack ACColorHex(@"000000")
#define ACColorLightGray ACColorHex(@"aaaaaa")

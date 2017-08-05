//
//  UIImage+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIImage+AppCore.h"

@implementation UIImage(AppCore)

+ (instancetype)ac_launchImage {
    UIScreen *mainScreen = [UIScreen mainScreen];
    NSString *launchImageName = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (mainScreen.bounds.size.height == 480) launchImageName = @"LaunchImage-700@2x.png"; // 3.5 inch
        if (mainScreen.bounds.size.height == 568) launchImageName = @"LaunchImage-700-568h@2x.png"; // 4.0 inch
        if (mainScreen.bounds.size.height == 667) launchImageName = @"LaunchImage-800-667h@2x.png"; // 4.7 inch
        if (mainScreen.bounds.size.height == 736) launchImageName = @"LaunchImage-800-Portrait-736h@3x.png"; // 5.5 inch
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (mainScreen.scale == 1) launchImageName = @"LaunchImage-700-Portrait~ipad.png"; // iPad 2
        if (mainScreen.scale == 2) launchImageName = @"LaunchImage-700-Portrait@2x~ipad.png"; // Retina iPads
    }
    
    return [UIImage imageNamed:launchImageName];
}

- (NSString *)ac_base64 {
    return [UIImageJPEGRepresentation(self, 1.) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)ac_resizeWithNewSize:(CGSize)newSize {
    CGFloat ratioW = self.size.width / newSize.width;
    CGFloat ratioH = self.size.height / newSize.height;
    CGFloat ratio = self.size.width / self.size.height;
    
    CGSize showSize = CGSizeZero;
    if (ratioW > 1. && ratioH > 1.) {
        if (ratioW > ratioH) {
            showSize.width = newSize.width;
            showSize.height = showSize.width / ratio;
        } else {
            showSize.height = newSize.height;
            showSize.width = showSize.height * ratio;
        }
    } else if (ratioW > 1.) {
        showSize.width = showSize.width;
        showSize.height = showSize.width / ratio;
    } else if (ratioH > 1.) {
        showSize.height = showSize.height;
        showSize.width = showSize.height * ratio;
    }
    
    UIGraphicsBeginImageContextWithOptions(showSize, NO, .0);
    [self drawInRect:CGRectMake(.0, .0, ceilf(showSize.width), ceilf(showSize.height))];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)ac_resizeWithMinSide:(CGFloat)minSide {
    return [self ac_resizeWithNewSize:((self.size.width > self.size.height)
                                       ? CGSizeMake(minSide * (self.size.width / self.size.height), minSide)
                                       : CGSizeMake(minSide, minSide * (self.size.height / self.size.width)))];
}

- (UIImage *)ac_imageWithInsets:(UIEdgeInsets)insets {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width + insets.left + insets.right,
                                                      self.size.height + insets.top + insets.bottom),
                                           NO,
                                           .0);
    [self drawInRect:CGRectMake(insets.left, insets.top, self.size.width, self.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)ac_alwaysTemplate {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)ac_alwaysOriginal {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end

//
//  UIImage+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIImage+AppCore.h"

@implementation UIImage(AppCore)

- (NSString *)ac_base64 {
    return [UIImageJPEGRepresentation(self, 1.) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)ac_resizeWithNewSize:(CGSize)newSize {
    CGFloat ratioW = self.size.width / newSize.width;
    CGFloat ratioH = self.size.height / newSize.height;
    CGFloat ratio = self.size.width / self.size.height;
    
    CGSize showSize = CGSizeZero;
    if(ratioW > 1. && ratioH > 1.) {
        if(ratioW > ratioH) {
            showSize.width = newSize.width;
            showSize.height = showSize.width / ratio;
        } else {
            showSize.height = newSize.height;
            showSize.width = showSize.height * ratio;
        }
    } else if(ratioW > 1.) {
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

@end

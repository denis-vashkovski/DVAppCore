//
//  UIImage+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(AppCore)
+ (instancetype)ac_launchImage;

- (NSString *)ac_base64;
- (UIImage *)ac_resizeWithNewSize:(CGSize)newSize;
- (UIImage *)ac_resizeWithMinSide:(CGFloat)minSide;
- (UIImage *)ac_imageWithInsets:(UIEdgeInsets)insets;

- (UIImage *)ac_alwaysTemplate;
- (UIImage *)ac_alwaysOriginal;
@end

#define ACImageNamed(name) [UIImage imageNamed:name]

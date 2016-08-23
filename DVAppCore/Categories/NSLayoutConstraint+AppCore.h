//
//  NSLayoutConstraint+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 27/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface NSLayoutConstraint(AppCore)
@property (nonatomic) IBInspectable NSUInteger ac_pixelConstant;

+ (NSArray<NSLayoutConstraint *> *)ac_constraintsWithVisualFormat:(NSString *)format views:(NSDictionary<NSString *,id> *)views;
@end

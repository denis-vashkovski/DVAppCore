//
//  NSLayoutConstraint+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 27/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSLayoutConstraint+AppCore.h"

#import "NSObject+AppCore.h"

@implementation NSLayoutConstraint(AppCore)
- (NSUInteger)ac_pixelConstant {
    return [objc_getAssociatedObject(self, @selector(ac_pixelConstant)) unsignedIntegerValue];
}

- (void)setAc_pixelConstant:(NSUInteger)ac_pixelConstant {
    objc_setAssociatedObject(self, @selector(ac_pixelConstant), [NSNumber numberWithUnsignedInteger:ac_pixelConstant], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.constant = (double)ac_pixelConstant / [UIScreen mainScreen].scale;
}

+ (NSArray<NSLayoutConstraint *> *)ac_constraintsWithVisualFormat:(NSString *)format views:(NSDictionary<NSString *,id> *)views {
    return [self constraintsWithVisualFormat:format options:0 metrics:nil views:views];
}
@end

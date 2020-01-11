//
//  NSLayoutConstraintHairline.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 17/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSLayoutConstraintHairline.h"

@implementation NSLayoutConstraintHairline

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.constant == 1) self.constant = (1. / [UIScreen mainScreen].scale);
}

@end

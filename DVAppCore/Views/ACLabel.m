//
//  ACLabel.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 09.01.2020.
//  Copyright © 2020 Denis Vashkovski. All rights reserved.
//

#import "ACLabel.h"

@implementation ACLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

@end

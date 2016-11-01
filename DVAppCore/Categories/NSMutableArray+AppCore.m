//
//  NSMutableArray+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 28/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSMutableArray+AppCore.h"

@implementation NSMutableArray(AppCore)

- (void)ac_shuffle {
    NSUInteger count = [self count];
    if (count < 1) return;
    
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end

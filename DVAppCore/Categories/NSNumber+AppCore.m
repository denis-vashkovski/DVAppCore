//
//  NSNumber+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 24/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSNumber+AppCore.h"

@implementation NSNumber(AppCore)

+ (NSInteger)ac_randomFrom:(NSInteger)from to:(NSInteger)to {
    return from + arc4random() % (to - from);
}

@end

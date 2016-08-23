//
//  NSArray+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSArray+AppCore.h"

@implementation NSArray(AppCore)

+ (BOOL)ac_isValidArray:(id)object {
    return (object && [object isKindOfClass:[NSArray class]] && !((NSArray *)object).ac_isEmpty);
}

- (BOOL)ac_isEmpty {
    return ![self count];
}

@end

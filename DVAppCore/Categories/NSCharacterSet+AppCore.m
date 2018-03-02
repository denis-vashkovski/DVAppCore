//
//  NSCharacterSet+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/11/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import "NSCharacterSet+AppCore.h"

#import "NSObject+AppCore.h"

AC_EXTERN_STRING_M_V(NSCharacterSetCyrillicLowercaseCharacters, @"абвгдеёжзийклмнопрстуфхцчшщъыьэюя")

@implementation NSCharacterSet(AppCore)

+ (NSCharacterSet *)ac_cyrillicCharacterSet {
    NSMutableCharacterSet *cyrillicCharacterSet = [self ac_lowercaseCyrillicCharacterSet].mutableCopy;
    [cyrillicCharacterSet formUnionWithCharacterSet:[self ac_uppercaseCyrillicCharacterSet]];
    
    return cyrillicCharacterSet.copy;
}

+ (NSCharacterSet *)ac_lowercaseCyrillicCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:NSCharacterSetCyrillicLowercaseCharacters];
}

+ (NSCharacterSet *)ac_uppercaseCyrillicCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:NSCharacterSetCyrillicLowercaseCharacters.uppercaseString];
}

@end

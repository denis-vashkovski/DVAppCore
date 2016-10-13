//
//  NSDictionary+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSDictionary+AppCore.h"

#import "NSString+AppCore.h"

@implementation NSDictionary(AppCore)

+ (BOOL)ac_isValidDictionary:(id)object {
    return (object && [object isKindOfClass:[NSDictionary class]] && !((NSDictionary *)object).ac_isEmpty);
}

- (BOOL)ac_isEmpty {
    return self.count == 0;
}

- (NSString *)ac_stringForKey:(NSString *)key fallback:(NSString *)fallback {
    id result = [self objectForKey:key];
    return (result && [result isKindOfClass:[NSString class]]) ? result : fallback;
}

- (NSString *)ac_stringForKey:(NSString *)key {
    return [self ac_stringForKey:key fallback:nil];
}

- (NSNumber *)ac_numberForKey:(NSString *)key {
    id result = [self objectForKey:key];
    return (result && [result isKindOfClass:[NSNumber class]]) ? result : [NSNumber new];
}

- (NSArray *)ac_arrayForKey:(NSString *)key {
    id result = [self objectForKey:key];
    return (result && [result isKindOfClass:[NSArray class]]) ? result : nil;
}

- (NSDictionary *)ac_dictionaryForKey:(NSString *)key {
    id result = [self objectForKey:key];
    return (result && [result isKindOfClass:[NSDictionary class]]) ? result : nil;
}

- (BOOL)ac_boolForKey:(NSString *)key {
    return [[self ac_numberForKey:key] boolValue];
}

- (int)ac_intForKey:(NSString *)key {
    return [[self ac_numberForKey:key] intValue];
}

- (float)ac_floatForKey:(NSString *)key {
    return [[self ac_numberForKey:key] floatValue];
}

- (NSData *)ac_jsonData {
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)ac_jsonString {
    return [[NSString alloc] initWithData:self.ac_jsonData encoding:NSUTF8StringEncoding].ac_removeAllWhitespaceAndNewlineAndTab;
}

@end

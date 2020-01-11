//
//  NSDictionary+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSDictionary+AppCore.h"

#import "NSString+AppCore.h"
#import "NSDate+AppCore.h"

@implementation NSDictionary(AppCore)

+ (instancetype)ac_dictionaryWithJson:(NSString *)json {
    return ACValidStr(json) ? [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:0
                                                              error:nil] : nil;
}

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

- (NSDate *)ac_dateForKey:(NSString *)key {
    id result = [self objectForKey:key];
    return (result && [result isKindOfClass:[NSDate class]]) ? result : nil;
}

- (NSDate *)ac_dateForKey:(NSString *)key
           withDateFormat:(NSString *)dateFormat
         localeIdentifier:(NSString *)localeIdentifier {
    
    NSString *dateData = [self ac_stringForKey:key];
    if (!ACValidStr(dateData)) {
        return nil;
    }

    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = dateFormat;
    
    if (ACValidStr(localeIdentifier)) {
        df.locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    }

    return [df dateFromString:dateData];
}

- (NSDate *)ac_dateForKey:(NSString *)key withDateFormat:(NSString *)dateFormat {
    return [self ac_dateForKey:key withDateFormat:dateFormat localeIdentifier:nil];
}

- (NSURL *)ac_urlForKey:(NSString *)key {
    NSString *urlData = [self ac_stringForKey:key];
    return ACValidStr(urlData) ? [NSURL URLWithString:urlData] : nil;
}

- (NSData *)ac_jsonData {
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)ac_jsonString {
    return [[NSString alloc] initWithData:self.ac_jsonData encoding:NSUTF8StringEncoding].ac_removeAllWhitespaceAndNewlineAndTab;
}

@end

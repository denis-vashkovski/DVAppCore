//
//  NSDictionary+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(AppCore)
+ (instancetype)ac_dictionaryWithJson:(NSString *)json;

+ (BOOL)ac_isValidDictionary:(id)object;
/*!
 @abstract Return YES if number elements in dictionary equals 0
 */
- (BOOL)ac_isEmpty;

- (NSString *)ac_stringForKey:(NSString *)key fallback:(NSString *)fallback;
- (NSString *)ac_stringForKey:(NSString *)key;
- (NSNumber *)ac_numberForKey:(NSString *)key;
- (NSArray *)ac_arrayForKey:(NSString *)key;
- (NSDictionary *)ac_dictionaryForKey:(NSString *)key;
- (BOOL)ac_boolForKey:(NSString *)key;
- (int)ac_intForKey:(NSString *)key;
- (float)ac_floatForKey:(NSString *)key;

- (NSDate *)ac_dateForKey:(NSString *)key;

- (NSDate *)ac_dateForKey:(NSString *)key
           withDateFormat:(NSString *)dateFormat
         localeIdentifier:(NSString *)localeIdentifier;

- (NSDate *)ac_dateForKey:(NSString *)key
           withDateFormat:(NSString *)dateFormat;

- (NSURL *)ac_urlForKey:(NSString *)key;

- (NSData *)ac_jsonData;
- (NSString *)ac_jsonString;
@end

#define ACValidDictionary(dictionary) [NSDictionary ac_isValidDictionary:dictionary]

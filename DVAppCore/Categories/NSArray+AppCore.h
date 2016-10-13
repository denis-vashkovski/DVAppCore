//
//  NSArray+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(AppCore)
+ (BOOL)ac_isValidArray:(id)object;
/*!
 @abstract Return YES if number elements in array equals 0
 */
- (BOOL)ac_isEmpty;

- (NSData *)ac_jsonData;
- (NSString *)ac_jsonString;
@end

#define ValidArray(array) [NSArray ac_isValidArray:array]

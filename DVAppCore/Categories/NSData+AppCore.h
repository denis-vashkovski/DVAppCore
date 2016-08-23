//
//  NSData+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(AppCore)
+ (NSString *)ac_MD5ByFilePath:(NSString *)path;

- (NSString *)ac_MD5;

/*!
 @abstract Return NSArray or NSDictionary
 */
- (id)ac_jsonToCollectionObject;
@end

//
//  ACJsonObject.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+AppCore.h"

@interface ACJsonObject : NSObject<NSCoding>
+ (NSArray *)ac_arrayObjectsByData:(NSArray<NSDictionary *> *)data classModel:(Class)classModel;
+ (NSArray *)ac_arrayObjectsPrefillByData:(NSArray<NSDictionary *> *)data classModel:(Class)classModel;

- (instancetype)initWithData:(NSDictionary *)data;
- (instancetype)initWithPrefillData:(NSDictionary *)data;

@property (nonatomic) long uniqueId;

- (NSDictionary *)rawData;
@end

AC_EXTERN_STRING_H(ACJsonObjectRawDataKey)

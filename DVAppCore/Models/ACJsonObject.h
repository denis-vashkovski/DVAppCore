//
//  ACJsonObject.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACJsonObject : NSObject
+ (NSArray *)ac_arrayObjectsByData:(NSArray<NSDictionary *> *)data classModel:(Class)classModel;
+ (NSArray *)ac_arrayObjectsPrefillByData:(NSArray<NSDictionary *> *)data classModel:(Class)classModel;

- (instancetype)initWithData:(NSDictionary *)data;
- (instancetype)initWithPrefillData:(NSDictionary *)data;

@property (nonatomic) long uniqueId;

- (NSDictionary *)rawData;
@end

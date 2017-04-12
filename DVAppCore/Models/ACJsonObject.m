//
//  ACJsonObject.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACJsonObject.h"

#import "NSObject+AppCore.h"

@implementation ACJsonObject

+ (NSArray *)ac_arrayObjectsByData:(NSArray<NSDictionary *> *)data classModel:(Class)classModel {
    NSMutableArray *objects = [NSMutableArray new];
    
    if (ACValidArray(data) && [classModel isSubclassOfClass:self.class]) {
        for (NSDictionary *objectData in data) {
            [objects addObject:[[classModel alloc] initWithData:objectData]];
        }
    }
    
    return objects.ac_isEmpty ? nil : [NSArray arrayWithArray:objects];
}

+ (NSArray *)ac_arrayObjectsPrefillByData:(NSArray<NSDictionary *> *)data classModel:(Class)classModel {
    NSMutableArray *objects = [NSMutableArray new];
    
    if (ACValidArray(data) && [classModel isSubclassOfClass:self.class]) {
        for (NSDictionary *objectData in data) {
            [objects addObject:[[classModel alloc] initWithPrefillData:objectData]];
        }
    }
    
    return objects.ac_isEmpty ? nil : [NSArray arrayWithArray:objects];
}

- (instancetype)initWithData:(NSDictionary *)data {
    if ((self = [super init]) && ACValid(data)) {
        NSNumber *idNumber = [data ac_numberForKey:@"id"];
        if (!idNumber) idNumber = [data ac_numberForKey:@"Id"];
        if (!idNumber) idNumber = [data ac_numberForKey:@"ID"];
        if (idNumber) _uniqueId = [idNumber longValue];
    }
    return self;
}

- (instancetype)initWithPrefillData:(NSDictionary *)data {
    if (self = [self initWithData:data]) {
        for (NSString *key in data.allKeys) {
            id object = [data objectForKey:key];
            
            if ([object isKindOfClass:[NSDictionary class]]) {
                Class propertyClass = [self ac_getTypeClassOfPropertyByName:key];
                if ([propertyClass isSubclassOfClass:[ACJsonObject class]]) {
                    object = [[propertyClass alloc] initWithPrefillData:(NSDictionary *)object];
                }
            } else if ([object isKindOfClass:[NSArray class]] && [((NSArray *)object).firstObject isKindOfClass:[NSDictionary class]]) {
                object = nil;
            }
            
            if (object) {
                [self ac_setValue:object forPropertyName:key];
            }
        }
    }
    return self;
}

@end

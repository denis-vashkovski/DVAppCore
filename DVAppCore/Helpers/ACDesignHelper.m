//
//  ACDesignHelper.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 19/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACDesignHelper.h"

#import "NSNotificationCenter+AppCore.h"
#import "NSString+AppCore.h"

#import "ACSingleton.h"

@implementation ACDesign
+ (NSDictionary *)design {
    return nil;
}
@end

EXTERN_STRING_M(ACUpdateDesign);

@interface ACDesignHelper()
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *designDictionary;
@property (nonatomic, strong) NSDictionary *currentDesign;
@end

@implementation ACDesignHelper
ACSINGLETON_M_INIT(initInstanceWith)

- (void)initInstanceWith {
    _designDictionary = [NSMutableDictionary new];
}

+ (id)valueByKey:(NSString *)key {
    id value = nil;
    if (ValidStr(key)) {
        value = [[[self getInstance] designDictionary] objectForKey:key];
        if (!value && [[self getInstance] currentDesign]) {
            value = [[[self getInstance] currentDesign] objectForKey:key];
        }
    }
    return value;
}

+ (BOOL)setValue:(id)value byKey:(NSString *)key {
    if (ValidStr(key) && value) {
        [[[self getInstance] designDictionary] setObject:value forKey:key];
        return YES;
    }
    return NO;
}

+ (void)setDesignClass:(Class)designClass {
    if (!designClass || ![designClass isSubclassOfClass:[ACDesign class]]) {
        return;
    }
    
    [[self getInstance] setCurrentDesign:[designClass design]];
    [[NSNotificationCenter defaultCenter] ac_postNotificationName:ACUpdateDesign];
}

@end

EXTERN_STRING_M(ACDesignColorRefreshControlTVC);
EXTERN_STRING_M(ACDesignColorProgressView);
EXTERN_STRING_M(ACDesignColorProgressActivityIndicator);
EXTERN_STRING_M(ACDesignColorWindowForAlerts);

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

- (void)setCurrentDesign:(NSDictionary *)currentDesign {
    _currentDesign = currentDesign;
    
    if (ValidArray(_currentDesign)) {
        for (NSString *key in _currentDesign.allKeys) {
            [self applyValue:_currentDesign[key] byKey:key];
        }
    }
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
        [[self getInstance] applyValue:value byKey:key];
        
        return YES;
    }
    return NO;
}

+ (void)setDesignClass:(Class)designClass {
    if (!designClass || ![designClass isSubclassOfClass:[ACDesign class]]) return;
    
    [[self getInstance] setCurrentDesign:[designClass design]];
    [[NSNotificationCenter defaultCenter] ac_postNotificationName:ACUpdateDesign];
}

- (void)applyValue:(id)value byKey:(NSString *)key {
    if (!ValidStr(key) || !value) return;
    
    if ([key isEqualToString:ACDesignColorNavigationBarTint]) {
        [[UINavigationBar appearance] setBarTintColor:ACDesign(ACDesignColorNavigationBarTint)];
    } else if ([key isEqualToString:ACDesignColorNavigationTint]) {
        [[UINavigationBar appearance] setTintColor:ACDesign(ACDesignColorNavigationTint)];
    } else if ([key isEqualToString:ACDesignAttributesNavigationTitleText]) {
        [[UINavigationBar appearance] setTitleTextAttributes:ACDesign(ACDesignAttributesNavigationTitleText)];
    } else if ([key isEqualToString:ACDesignColorTabBarTint]) {
        [[UITabBar appearance] setBarTintColor:ACDesign(ACDesignColorTabBarTint)];
    } else if ([key isEqualToString:ACDesignColorTabTint]) {
        [[UITabBar appearance] setTintColor:ACDesign(ACDesignColorTabTint)];
    } else if ([key isEqualToString:ACDesignAttributesTabItemTitleTextAttributes]) {
        [[UITabBarItem appearance] setTitleTextAttributes:ACDesign(ACDesignAttributesTabItemTitleTextAttributes) forState:UIControlStateNormal];
    } else if ([key isEqualToString:ACDesignAttributesTabItemSelectedTitleTextAttributes]) {
        [[UITabBarItem appearance] setTitleTextAttributes:ACDesign(ACDesignAttributesTabItemSelectedTitleTextAttributes) forState:UIControlStateSelected];
    } else if ([key isEqualToString:ACDesignPositionAdjustmentTabItemTitle]) {
        [[UITabBarItem appearance] setTitlePositionAdjustment:((NSValue *)ACDesign(ACDesignPositionAdjustmentTabItemTitle)).UIOffsetValue];
    }
}

@end

EXTERN_STRING_M(ACDesignColorRefreshControlTVC);
EXTERN_STRING_M(ACDesignColorProgressView);
EXTERN_STRING_M(ACDesignColorProgressActivityIndicator);
EXTERN_STRING_M(ACDesignColorWindowForAlerts);

// global design
EXTERN_STRING_M(ACDesignColorNavigationBarTint)
EXTERN_STRING_M(ACDesignColorNavigationTint)
EXTERN_STRING_M(ACDesignAttributesNavigationTitleText)

EXTERN_STRING_M(ACDesignColorTabBarTint)
EXTERN_STRING_M(ACDesignColorTabTint)
EXTERN_STRING_M(ACDesignAttributesTabItemTitleTextAttributes)
EXTERN_STRING_M(ACDesignAttributesTabItemSelectedTitleTextAttributes)
EXTERN_STRING_M(ACDesignPositionAdjustmentTabItemTitle)

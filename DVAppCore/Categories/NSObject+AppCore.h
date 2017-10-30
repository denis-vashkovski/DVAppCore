//
//  NSObject+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "NSArray+AppCore.h"
#import "NSDictionary+AppCore.h"
#import "NSString+AppCore.h"

@interface NSObject(AppCore)
+ (void)ac_addSwizzlingSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector;

- (Class)ac_getTypeClassOfPropertyByName:(NSString *)propertyName;
- (BOOL)ac_hasPropertyByName:(NSString *)propertyName;
- (void)ac_setValue:(id)value forPropertyName:(NSString *)propertyName;

- (BOOL)ac_saveObjectToAppDocumets:(id)object byName:(NSString *)name;
- (id)ac_objectFromAppDocumentsByName:(NSString *)name;
- (BOOL)ac_removeAppDocumentByName:(NSString *)name;

- (void)ac_executeInMainThread:(void (^)(void))handler;
@end

#define ACValid(object)   [object isKindOfClass:[NSArray class]]        ? ACValidArray(object) : \
                          [object isKindOfClass:[NSDictionary class]]   ? ACValidDictionary(object) : \
                          [object isKindOfClass:[NSString class]]       ? ACValidStr(object) : \
                          YES

#pragma mark - CATEGORY_PROPERTY
#define AC_CATEGORY_PROPERTY_GET(type, property) \
- (type) property { \
    return objc_getAssociatedObject(self, @selector(property)); \
}

#define AC_CATEGORY_PROPERTY_SET(type, property, setter) \
- (void) setter (type) property { \
    objc_setAssociatedObject(self, @selector(property), property, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
}

#define AC_CATEGORY_PROPERTY_GET_SET(type, property, setter) AC_CATEGORY_PROPERTY_GET(type, property) AC_CATEGORY_PROPERTY_SET(type, property, setter)

#define AC_CATEGORY_PROPERTY_GET_NSNUMBER_PRIMITIVE(type, property, valueSelector) \
- (type) property { \
    return [objc_getAssociatedObject(self, @selector(property)) valueSelector]; \
}

#define AC_CATEGORY_PROPERTY_SET_NSNUMBER_PRIMITIVE(type, property, setter, numberSelector) \
- (void) setter (type) property { \
    objc_setAssociatedObject(self, @selector(property), [NSNumber numberSelector: property], OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
}

#define AC_CATEGORY_PROPERTY_GET_UINT(property) AC_CATEGORY_PROPERTY_GET_NSNUMBER_PRIMITIVE(unsigned int, property, unsignedIntValue)
#define AC_CATEGORY_PROPERTY_SET_UINT(property, setter) AC_CATEGORY_PROPERTY_SET_NSNUMBER_PRIMITIVE(unsigned int, property, setter, numberWithUnsignedInt)
#define AC_CATEGORY_PROPERTY_GET_SET_UINT(property, setter) AC_CATEGORY_PROPERTY_GET_UINT(property) AC_CATEGORY_PROPERTY_SET_UINT(property, setter)


#define AC_CATEGORY_PROPERTY_GET_BOOL(property) AC_CATEGORY_PROPERTY_GET_NSNUMBER_PRIMITIVE(BOOL, property, boolValue)
#define AC_CATEGORY_PROPERTY_SET_BOOL(property, setter) AC_CATEGORY_PROPERTY_SET_NSNUMBER_PRIMITIVE(BOOL, property, setter, numberWithBool)
#define AC_CATEGORY_PROPERTY_GET_SET_BOOL(property, setter) AC_CATEGORY_PROPERTY_GET_BOOL(property) AC_CATEGORY_PROPERTY_SET_BOOL(property, setter)

#pragma mark - Extern
#define AC_EXTERN_STRING_H(name) extern NSString * const (name);
#define AC_EXTERN_STRING_M(name) NSString * const (name) = (@""#name);
#define AC_EXTERN_STRING_M_V(name, value) NSString * const (name) = (value);

#pragma mark - Standart creating
#define AC_STANDART_CREATING_NOT_AVAILABLE(instead) \
+ (instancetype) alloc __attribute__((unavailable("alloc not available, call (instead) instead"))); \
- (instancetype) init __attribute__((unavailable("init not available, call (instead) instead"))); \
+ (instancetype) new __attribute__((unavailable("new not available, call (instead) instead")));

#pragma mark - Load once
#define AC_LOAD_ONCE(code) \
+ (void)load { \
    static dispatch_once_t once; \
    dispatch_once(&once, ^{ \
        code \
    }); \
}

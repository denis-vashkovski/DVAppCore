//
//  ACSingleton.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 19/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSObject+AppCore.h"

#pragma mark - ACSingleton.h
#define ACSINGLETON_H \
STANDART_CREATING_NOT_AVAILABLE(@"getInstance"); \
+ (instancetype)getInstance;

#define ACSINGLETON_H_METHOD(method_name) \
STANDART_CREATING_NOT_AVAILABLE(@""#method_name); \
+ (instancetype)method_name;

#pragma mark - ACSingleton.m
#define ACSINGLETON_M ACSINGLETON_M_METHOD(getInstance)

#define ACSINGLETON_M_INIT(init_method_name) ACSINGLETON_M_METHOD_INIT(getInstance, init_method_name)

#define ACSINGLETON_M_METHOD(method_name) \
+ (instancetype)method_name { \
static id instance; \
static dispatch_once_t once; \
dispatch_once(&once, ^{ \
instance = [[super alloc] initUniqueInstance]; \
}); \
return instance; \
} \
\
- (instancetype)initUniqueInstance { \
return [super init]; \
}

#define ACSINGLETON_M_METHOD_INIT(method_name, init_method_name) \
+ (instancetype)method_name { \
static id instance; \
static dispatch_once_t once; \
dispatch_once(&once, ^{ \
instance = [[super alloc] initUniqueInstance]; \
}); \
return instance; \
} \
\
- (instancetype)initUniqueInstance { \
if (self = [super init]) { \
[self init_method_name]; \
} \
return self; \
}

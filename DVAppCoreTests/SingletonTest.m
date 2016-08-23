//
//  SingletonTest.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ACSingleton.h"

#pragma mark - Singleton1Object
@interface Singleton1Object : NSObject
ACSINGLETON_H
@end
@implementation Singleton1Object
ACSINGLETON_M
@end

#pragma mark - Singleton2Object
@interface Singleton2Object : NSObject
ACSINGLETON_H
@end
@implementation Singleton2Object
ACSINGLETON_M
@end

#pragma mark - SingletonTest
@interface SingletonTest : XCTestCase
@end

@implementation SingletonTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSingleton {
    Singleton1Object *singleton1Object1 = [Singleton1Object getInstance];
    Singleton1Object *singleton1Object2 = [Singleton1Object getInstance];
    
    XCTAssertEqualObjects(singleton1Object1, singleton1Object2);
    
    Singleton2Object *singleton2Object1 = [Singleton2Object getInstance];
    Singleton2Object *singleton2Object2 = [Singleton2Object getInstance];
    
    XCTAssertEqualObjects(singleton2Object1, singleton2Object2);
    XCTAssertNotEqualObjects(singleton1Object1, singleton2Object1);
}

@end

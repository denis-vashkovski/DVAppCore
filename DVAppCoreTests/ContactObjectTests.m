//
//  ContactObjectTests.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 31/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ACContactsHelper.h"

@interface ContactObjectTests : XCTestCase

@end

@implementation ContactObjectTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    ACContactObject *contactObject = [ACContactObject new];
    [contactObject setFirstName:@"ivan"];
    [contactObject setLastName:@"pupkin"];
    
    XCTAssertEqualObjects(contactObject.nameFull, @"Ivan Pupkin");
    XCTAssertEqualObjects(contactObject.nameShort, @"Ivan P.");
    
    [contactObject setLastName:nil];
    XCTAssertEqualObjects(contactObject.nameFull, @"Ivan");
    XCTAssertEqualObjects(contactObject.nameShort, @"Ivan");
    
    [contactObject setFirstName:nil];
    XCTAssertNil(contactObject.nameFull);
    XCTAssertNil(contactObject.nameShort);
    
    [contactObject setLastName:@"pupkin"];
    XCTAssertEqualObjects(contactObject.nameFull, @"Pupkin");
    XCTAssertEqualObjects(contactObject.nameShort, @"Pupkin");
}

@end

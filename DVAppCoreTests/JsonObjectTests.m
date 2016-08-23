//
//  JsonObjectTests.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ACJsonObject.h"
#import "NSDictionary+AppCore.h"

@interface Skill : ACJsonObject
@property (nonatomic, strong) NSString *title;
@end
@implementation Skill
- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super initWithData:data]) {
        _title = [data ac_stringForKey:@"title"];
    }
    return self;
}
@end
@interface UserObject : ACJsonObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger age;
@property (nonatomic, strong) Skill *skill;
@end
@implementation UserObject
- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super initWithData:data]) {
        _name = [data ac_stringForKey:@"name"];
        _age = [data ac_numberForKey:@"age"].unsignedIntegerValue;
        _skill = [[Skill alloc] initWithData:[data ac_dictionaryForKey:@"skill"]];
    }
    return self;
}
@end

@interface JsonObjectTests : XCTestCase

@end

@implementation JsonObjectTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitWithData {
    ACJsonObject *jsonObject = [[ACJsonObject alloc] initWithData:@{ @"id": @(1) }];
    XCTAssertEqual(jsonObject.uniqueId, 1);
    
    jsonObject = [[ACJsonObject alloc] initWithData:@{ @"id": @(2) }];
    XCTAssertEqual(jsonObject.uniqueId, 2);
    
    jsonObject = [[ACJsonObject alloc] initWithData:nil];
    XCTAssertEqual(jsonObject.uniqueId, 0);
}

- (void)testInitWithPrefillData {
    UserObject *userObject = [[UserObject alloc] initWithPrefillData:@{ @"id": @(666),
                                                                        @"name": @"FirstName LastName",
                                                                        @"age": @(66),
                                                                        @"skill": @{ @"id": @(123),
                                                                                     @"title": @"Skill_1" } }];
    XCTAssertEqual(userObject.uniqueId, 666);
    XCTAssertEqualObjects(userObject.name, @"FirstName LastName");
    XCTAssertEqual(userObject.age, 66);
    
    XCTAssertNotNil(userObject.skill);
    XCTAssertEqual(userObject.skill.uniqueId, 123);
    XCTAssertEqualObjects(userObject.skill.title, @"Skill_1");
}

- (void)testArrayObjectsByData {
    NSArray<UserObject *> *objects = [ACJsonObject ac_arrayObjectsByData:nil
                                                classModel:[UserObject class]];
    XCTAssertNil(objects);
    
    objects = [ACJsonObject ac_arrayObjectsByData:@[@{ @"id": @(1),
                                                       @"name": @"Name1",
                                                       @"age": @(1) }]
                                       classModel:[NSString class]];
    XCTAssertNil(objects);
    
    objects = [ACJsonObject ac_arrayObjectsByData:@[ @{ @"id": @(1),
                                                        @"name": @"Name1",
                                                        @"age": @(1) },
                                                     @{ @"id": @(2),
                                                        @"name": @"Name2",
                                                        @"age": @(2) },
                                                     @{ @"id": @(3),
                                                        @"name": @"Name3",
                                                        @"age": @(3) } ]
                                       classModel:[UserObject class]];
    
    XCTAssertNotNil(objects);
    XCTAssertEqual(objects.count, 3);
    XCTAssertTrue([[UserObject class] isSubclassOfClass:objects.firstObject.class]);
    
    XCTAssertEqual(objects[0].uniqueId, 1);
    XCTAssertEqualObjects(objects[0].name, @"Name1");
    XCTAssertEqual(objects[0].age, 1);
    
    XCTAssertEqual(objects[1].uniqueId, 2);
    XCTAssertEqualObjects(objects[1].name, @"Name2");
    XCTAssertEqual(objects[1].age, 2);
    
    XCTAssertEqual(objects[2].uniqueId, 3);
    XCTAssertEqualObjects(objects[2].name, @"Name3");
    XCTAssertEqual(objects[2].age, 3);
}

@end

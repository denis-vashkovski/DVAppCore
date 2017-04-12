//
//  DVAppCoreTests.m
//  DVAppCoreTests
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ACCategories.h"

@interface TestObject : NSObject
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dict;
@end
@implementation TestObject
@end

@interface NSCategoriesTests : XCTestCase

@end

@implementation NSCategoriesTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNSArray {
    NSArray *array = [NSArray new];
    XCTAssertTrue(array.ac_isEmpty);
    
    array = @[@""];
    XCTAssertFalse(array.ac_isEmpty);
    
    XCTAssertTrue(ACValidArray(array));
    XCTAssertFalse(ACValidArray(@""));
}

- (void)testNSAttributedString {
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"test"
                                                                  attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:10] }];
    XCTAssertEqual(ceilf([attrStr ac_heightForWidth:CGFLOAT_MAX]), 12);
    XCTAssertEqual(ceilf([attrStr ac_widthByMaxWidth:CGFLOAT_MAX]), 17);
    XCTAssertEqual(ceilf(attrStr.ac_width), 17);
    
    attrStr = [[NSAttributedString alloc] initWithString:@"test test"
                                              attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:10] }];
    XCTAssertEqual(ceilf([attrStr ac_heightForWidth:CGFLOAT_MAX]), 12);
    XCTAssertEqual(ceilf([attrStr ac_widthByMaxWidth:CGFLOAT_MAX]), 36);
    XCTAssertEqual(ceilf(attrStr.ac_width), 36);
    XCTAssertEqual(ceilf([attrStr ac_heightForWidth:12]), 46);
    XCTAssertEqual(ceilf([attrStr ac_widthByMaxWidth:15]), 14);
}

- (void)testNSData {
    NSString *jsonStr = @"{ \"id\": 1}";
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNotNil(jsonData.ac_jsonToCollectionObject);
    XCTAssertTrue([jsonData.ac_jsonToCollectionObject isKindOfClass:[NSDictionary class]]);
    
    jsonStr = @"[1, 2, 3]";
    jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNotNil(jsonData.ac_jsonToCollectionObject);
    XCTAssertTrue([jsonData.ac_jsonToCollectionObject isKindOfClass:[NSArray class]]);
    
    jsonStr = @"";
    jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNil(jsonData.ac_jsonToCollectionObject);
    
    jsonStr = @"test";
    jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(jsonData.ac_MD5, @"098f6bcd4621d373cade4e832627b4f6");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[[paths firstObject] copy] stringByAppendingString:@"/file_test"];
    if ([jsonData writeToFile:documentsDirectory atomically:YES]) {
        XCTAssertEqualObjects([NSData ac_MD5ByFilePath:documentsDirectory], jsonData.ac_MD5);
    }
}

- (void)testNSDate {
    NSDate *date = [NSDate ac_date:@"13/03/2016 17:29" dateFormat:@"dd/MM/yyyy HH:mm"];
    XCTAssertEqual(date.ac_day, 13);
    XCTAssertEqual(date.ac_month, 3);
    XCTAssertEqual(date.ac_year, 2016);
    XCTAssertEqual(date.ac_hour, 17);
    XCTAssertEqual(date.ac_minute, 29);
    
    NSString *dateString = [date ac_stringWithFormat:@"dd.MM.yyyy"];
    XCTAssertEqualObjects(dateString, @"13.03.2016");
    
    XCTAssertTrue(date.ac_isWeekend);
    
    date = [date ac_dateByAddingDay:2];
    XCTAssertEqual(date.ac_day, 15);
    
    XCTAssertFalse(date.ac_isWeekend);
    
    date = date.ac_nextDay;
    XCTAssertEqual(date.ac_day, 16);
    
    date = date.ac_previousDay;
    XCTAssertEqual(date.ac_day, 15);
    
    date = date.ac_beginDay;
    XCTAssertEqual(date.ac_hour, 0);
    XCTAssertEqual(date.ac_minute, 0);
    
    XCTAssertTrue([date ac_isTheSameDayThan:[NSDate ac_date:@"15/03/2016" dateFormat:@"dd/MM/yyyy"]]);
    XCTAssertFalse([date ac_isTheSameDayThan:[NSDate ac_date:@"13/03/2016" dateFormat:@"dd/MM/yyyy"]]);
    
    XCTAssertEqual([NSDate ac_date:@"14/03/2015" dateFormat:@"dd/MM/yyyy"].ac_age, 2);
}

- (void)testNSDictionary {
    NSDictionary *dict = [NSDictionary new];
    XCTAssertTrue(dict.ac_isEmpty);
    
    dict = @{ @"key1": @"value1",
              @"key2": @(1),
              @"key3": @(YES),
              @"key4": @[],
              @"key5": @{},
              @"key6": @(1.) };
    XCTAssertFalse(dict.ac_isEmpty);
    XCTAssertEqualObjects([dict ac_stringForKey:@"key1" fallback:@""], @"value1");
    XCTAssertEqualObjects([dict ac_stringForKey:@"key2" fallback:@"test"], @"test");
    XCTAssertNil([dict ac_stringForKey:@"key2"]);
    XCTAssertTrue([[dict ac_numberForKey:@"key2"] isKindOfClass:[NSNumber class]]);
    XCTAssertEqual([dict ac_numberForKey:@"key2"].intValue, 1);
    XCTAssertEqual([dict ac_intForKey:@"key2"], 1);
    XCTAssertEqual([dict ac_boolForKey:@"key3"], YES);
    XCTAssertNotNil([dict ac_arrayForKey:@"key4"]);
    XCTAssertNotNil([dict ac_dictionaryForKey:@"key5"]);
    XCTAssertEqual([dict ac_floatForKey:@"key6"], 1.);
}

- (void)testNSHTTPURLResponse {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com"]
                                                              statusCode:200
                                                             HTTPVersion:nil
                                                            headerFields:nil];
    XCTAssertTrue(response.ac_isStatusCorrect);
    
    response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com"]
                                           statusCode:400
                                          HTTPVersion:nil
                                         headerFields:nil];
    XCTAssertFalse(response.ac_isStatusCorrect);
    
    response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com"]
                                           statusCode:202
                                          HTTPVersion:nil
                                         headerFields:nil];
    XCTAssertTrue(response.ac_isStatusCorrect);
}

- (void)testNSMutableURLRequest {
    NSUInteger numberOfBytes = 1;
    void * bytes = malloc(numberOfBytes);
    NSData *data = [NSData dataWithBytes:bytes length:numberOfBytes];
    free(bytes);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setHTTPBody:data];
    XCTAssertEqual(request.HTTPBody.length, 1);
    
    bytes = malloc(numberOfBytes);
    data = [NSData dataWithBytes:bytes length:numberOfBytes];
    free(bytes);
    [request ac_appendData:@[data]];
    XCTAssertGreaterThan(request.HTTPBody.length, 1);
}

- (void)testNSObject {
    TestObject *testObject = [TestObject new];
    
    XCTAssertTrue([testObject ac_hasPropertyByName:@"array"]);
    XCTAssertEqualObjects(NSStringFromClass([testObject ac_getTypeClassOfPropertyByName:@"array"]), NSStringFromClass([NSArray class]));
    XCTAssertNil(testObject.array);
    
    XCTAssertTrue([testObject ac_hasPropertyByName:@"dict"]);
    XCTAssertEqualObjects(NSStringFromClass([testObject ac_getTypeClassOfPropertyByName:@"dict"]), NSStringFromClass([NSDictionary class]));
    XCTAssertNil(testObject.dict);
    
    [testObject ac_setValue:@[] forPropertyName:@"array"];
    XCTAssertNotNil(testObject.array);
    
    [testObject ac_setValue:@{} forPropertyName:@"dict"];
    XCTAssertNotNil(testObject.dict);
    
    XCTAssertTrue(ACValidStr(@"test"));
    XCTAssertFalse(ACValidStr(@""));
    
    XCTAssertTrue(ACValidArray(@[@""]));
    XCTAssertFalse(ACValidArray(@[]));
    
    XCTAssertTrue(ACValidDictionary(@{@"key": @""}));
    XCTAssertFalse(ACValidArray(@{}));
    
    XCTAssertTrue(ACValid(@"test"));
    XCTAssertFalse(ACValid(@""));
    
    XCTAssertTrue(ACValid(@[@""]));
    XCTAssertFalse(ACValid(@[]));
    
    XCTAssertTrue(ACValid(@{@"key": @""}));
    XCTAssertFalse(ACValid(@{}));
}

- (void)testNSString {
    NSString *str = @"";
    XCTAssertTrue(str.ac_isEmpty);
    
    str = @"test";
    XCTAssertFalse(str.ac_isEmpty);
    XCTAssertTrue([str ac_isContains:@"es"]);
    XCTAssertFalse([str ac_isContains:@"qw"]);
    
    XCTAssertEqual(ceilf([str ac_heightForFont:[UIFont fontWithName:@"Helvetica" size:10] andWidth:CGFLOAT_MAX]), 12);
    XCTAssertEqual(ceilf([str ac_widthForFont:[UIFont fontWithName:@"Helvetica" size:10] andHeight:CGFLOAT_MAX]), 17);
    
    str = @"test test";
    XCTAssertEqual(ceilf([str ac_heightForFont:[UIFont fontWithName:@"Helvetica" size:10] andWidth:CGFLOAT_MAX]), 12);
    XCTAssertEqual(ceilf([str ac_widthForFont:[UIFont fontWithName:@"Helvetica" size:10] andHeight:CGFLOAT_MAX]), 36);
    XCTAssertEqual(ceilf([str ac_heightForFont:[UIFont fontWithName:@"Helvetica" size:10] andWidth:12]), 46);
    XCTAssertEqual(ceilf([str ac_widthForFont:[UIFont fontWithName:@"Helvetica" size:10] andHeight:15]), 36);
    
    str = @"\" ^";
    XCTAssertEqualObjects(str.ac_stringByAddingPercentEscapes, @"%22%20%5E");
    
    str = @" test  ";
    XCTAssertEqualObjects(str.ac_trim, @"test");
    
    str = @"\" ^";
    XCTAssertEqualObjects(str.ac_encodeForUrl, @"%22%20%5E");
    
    str = nil;
    XCTAssertEqualObjects(ACUnnilStr(str), @"");
    
    // regexp
    str = @"test@test.com";
    XCTAssertTrue(str.ac_isValidEmail);
    str = @"test@testcom";
    XCTAssertFalse(str.ac_isValidEmail);
    
    str = @"1234123412341234";
    XCTAssertTrue(str.ac_isValidCreditCardNumber);
    str = @"12341234123412341";
    XCTAssertFalse(str.ac_isValidCreditCardNumber);
    
    str = @"example.com";
    XCTAssertTrue(str.ac_isValidDomain);
    str = @"http://example.com";
    XCTAssertFalse(str.ac_isValidDomain);
    
    str = @"http://example.com";
    XCTAssertTrue(str.ac_isValidURL);
    str = @"example.com/===";
    XCTAssertFalse(str.ac_isValidURL);
    
    str = @"01237864";
    XCTAssertTrue(str.ac_isOnlyDigits);
    str = @"2345145g";
    XCTAssertFalse(str.ac_isOnlyDigits);
    
    str = @"qerqewr";
    XCTAssertTrue(str.ac_isOnlyLetters);
    str = @"kjdfhsakjdfhj32";
    XCTAssertFalse(str.ac_isOnlyLetters);
    
    str = @"qerqewr123123";
    XCTAssertTrue(str.ac_isOnlyLettersAndDigits);
    str = @"kjdfhsakjdfhj32=";
    XCTAssertFalse(str.ac_isOnlyLettersAndDigits);
}

- (void)testNSURLRequest {
    // GET by link
    NSURLRequest *request = [NSURLRequest ac_requestGetByLink:@"http://example.com" parameters:@{ @"key": @"value", @"key2": @(1), @"key3": @(NO) } headerFields:@{ @"key": @"value" }];
    XCTAssertTrue([request.URL.absoluteString ac_isContains:@"key=value"]);
    XCTAssertTrue([request.URL.absoluteString ac_isContains:@"key2=1"]);
    XCTAssertTrue([request.URL.absoluteString ac_isContains:@"key3=0"]);
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"key"], @"value");
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    request = [NSURLRequest ac_requestGetByLink:@"http://example.com" parameters:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"http://example.com?key=value");
    XCTAssertNil(request.allHTTPHeaderFields);
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    request = [NSURLRequest ac_requestGetByLink:@"http://example.com" parameters:@{ @"key": @[ @"value1", @"value2" ] }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"http://example.com?key%5B%5D=value1&key%5B%5D=value2");
    XCTAssertNil(request.allHTTPHeaderFields);
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    request = [NSURLRequest ac_requestGetByLink:@"http://example.com" parameters:@{ @"key": @[] }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"http://example.com?key%5B%5D=");
    XCTAssertNil(request.allHTTPHeaderFields);
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    request = [NSURLRequest ac_requestGetByLink:@"http://example.com"];
    XCTAssertEqualObjects(request.URL.absoluteString, @"http://example.com");
    XCTAssertNil(request.allHTTPHeaderFields);
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    // GET
    request = [NSURLRequest ac_requestGetForRootLinkByHref:@"example" parameters:@{ @"key": @"value" } headerFields:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example?key=value");
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"key"], @"value");
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    request = [NSURLRequest ac_requestGetForRootLinkByHref:@"example" parameters:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example?key=value");
    XCTAssertNil(request.allHTTPHeaderFields);
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    request = [NSURLRequest ac_requestGetForRootLinkByHref:@"example"];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNil(request.allHTTPHeaderFields);
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    
    // POST
    request = [NSURLRequest ac_requestPostForRootLinkByHref:@"example" parameters:@{ @"key": @"value", @"key2": @(1), @"key3": @(NO) } headerFields:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    NSString *httpBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([httpBody ac_isContains:@"key=value"]);
    XCTAssertTrue([httpBody ac_isContains:@"key2=1"]);
    XCTAssertTrue([httpBody ac_isContains:@"key3=0"]);
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"key"], @"value");
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    
    request = [NSURLRequest ac_requestPostForRootLinkByHref:@"example" parameters:@{ @"key": @[ @"value1", @"value2" ] }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    httpBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([httpBody ac_isContains:@"key%5B%5D=value1"]);
    XCTAssertTrue([httpBody ac_isContains:@"key%5B%5D=value2"]);
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    
    request = [NSURLRequest ac_requestPostForRootLinkByHref:@"example" parameters:@{ @"key": @[] }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    httpBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([httpBody ac_isContains:@"key%5B%5D="]);
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    
    request = [NSURLRequest ac_requestPostForRootLinkByHref:@"example" parameters:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    XCTAssertEqualObjects([[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding], @"key=value");
    XCTAssertFalse(request.allHTTPHeaderFields.ac_isEmpty);
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    
    request = [NSURLRequest ac_requestPostForRootLinkByHref:@"example"];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertTrue(ACValid(request.allHTTPHeaderFields));
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    
    // PUT
    request = [NSURLRequest ac_requestPutForRootLinkByHref:@"example" parameters:@{ @"key": @"value" } headerFields:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    XCTAssertEqualObjects([[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding], @"key=value");
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"key"], @"value");
    XCTAssertEqualObjects(request.HTTPMethod, @"PUT");
    
    request = [NSURLRequest ac_requestPutForRootLinkByHref:@"example" parameters:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    XCTAssertEqualObjects([[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding], @"key=value");
    XCTAssertEqualObjects(request.HTTPMethod, @"PUT");
    
    request = [NSURLRequest ac_requestPutForRootLinkByHref:@"example"];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertEqualObjects(request.HTTPMethod, @"PUT");
    
    // DELETE
    request = [NSURLRequest ac_requestDeleteForRootLinkByHref:@"example" parameters:@{ @"key": @"value" } headerFields:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    XCTAssertEqualObjects([[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding], @"key=value");
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"key"], @"value");
    XCTAssertEqualObjects(request.HTTPMethod, @"DELETE");
    
    request = [NSURLRequest ac_requestDeleteForRootLinkByHref:@"example" parameters:@{ @"key": @"value" }];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertNotNil(request.HTTPBody);
    XCTAssertEqualObjects([[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding], @"key=value");
    XCTAssertEqualObjects(request.HTTPMethod, @"DELETE");
    
    request = [NSURLRequest ac_requestDeleteForRootLinkByHref:@"example"];
    XCTAssertEqualObjects(request.URL.absoluteString, @"example");
    XCTAssertEqualObjects(request.HTTPMethod, @"DELETE");
    
    // Send
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing async send request method"];
    [request ac_sendAsynchronousWithCompletionHandler:^(id data, NSHTTPURLResponse *response) {
        XCTAssertNil(data);
        XCTAssertNil(response);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:61.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
    NSHTTPURLResponse *response = nil;
    NSData *data = [request ac_sendSynchronousWithResponse:&response];
    XCTAssertNil(data);
    XCTAssertNil(response);
}

@end

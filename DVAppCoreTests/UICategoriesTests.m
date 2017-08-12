//
//  UICategoriesTests.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ACCategories.h"

@interface UICategoriesTests : XCTestCase

@end

@implementation UICategoriesTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUIColor {
    UIColor *color1 = [UIColor colorWithRed:1. green:1. blue:1. alpha:1.];
    UIColor *color2 = [UIColor whiteColor];
    XCTAssertTrue([color1 ac_isEqualToColor:color2]);
    
    color1 = [UIColor ac_colorFromHexString:@""];
    XCTAssertNil(color1);
    
    color1 = [UIColor ac_colorFromHexString:@"#ffffff"];
    XCTAssertTrue([color1 ac_isEqualToColor:color2]);
    
    color1 = [UIColor ac_colorFromHexString:@"ffffff"];
    XCTAssertTrue([color1 ac_isEqualToColor:color2]);
    
    color1 = [UIColor ac_colorFromHexString:@"#ff0000"];
    XCTAssertFalse([color1 ac_isEqualToColor:color2]);
    
    color1 = [UIColor ac_colorFromHexString:@"#ffffff" alpha:.5];
    color2 = [UIColor colorWithWhite:1. alpha:.5];
    XCTAssertTrue([color1 ac_isEqualToColor:color2]);
}

- (void)testUIImage {
    CGSize size = CGSizeMake(100., 100.);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(.0, .0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    XCTAssertEqualObjects(NSStringFromCGSize([image ac_resizeWithNewSize:CGSizeMake(70., 50.)].size),
                          NSStringFromCGSize(CGSizeMake(50., 50.)));
    
    XCTAssertEqualObjects(NSStringFromCGSize([image ac_resizeWithMinSide:50.].size),
                          NSStringFromCGSize(CGSizeMake(50., 50.)));
    
// TODO problem with testing ac_base64
//    XCTAssertEqualObjects([image ac_resizeWithMinSide:1.].ac_base64, @"/9j/4AAQSkZJRgABAQAAAAAAAAD/4QCARXhpZgAATU0AKgAAAAgABQESAAMAAAAB\r\nAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAAB\r\nAAAAWgAAAAAAAAAAAAAAAQAAAAAAAAABAAKgAgAEAAAAAQAAAAKgAwAEAAAAAQAA\r\nAAIAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ\r\n1B2M2Y8AsgTpgAmY7PhCfv/AABEIAAIAAgMBEQACEQEDEQH/xAAfAAABBQEBAQEB\r\nAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEF\r\nEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4\r\nOTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaX\r\nmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp\r\n6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1\r\nEQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS\r\n8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZn\r\naGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrC\r\nw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2wBDAAEBAQEBAQEB\r\nAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\r\nAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\r\nAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/3QAEAAH/2gAMAwEAAhEDEQA/\r\nAP7+KAP/2Q==");
}

- (void)testUIImageView {
    UIImageView *imageView = [UIImageView new];
    XCTAssertNil(imageView.image);
    
    [imageView ac_setDefaultImage];
    XCTAssertNotNil(imageView.image);
    XCTAssertEqualObjects(UIImagePNGRepresentation(imageView.image), UIImagePNGRepresentation([UIImage imageNamed:@"default"]));
}

- (void)testUILabel {
    UILabel *label = [UILabel new];
    XCTAssertEqualObjects(NSStringFromUIEdgeInsets(label.ac_textInsets), NSStringFromUIEdgeInsets(UIEdgeInsetsZero));
    
    [label setAc_textInsets:UIEdgeInsetsMake(10., .0, .0, .0)];
    XCTAssertEqual(label.ac_textInsets.top, 10.);
}

- (void)testUINavigationController {
    UIViewController *firstVC = [UIViewController new];
    UIViewController *secondVC = [UIViewController new];
    UIViewController *thirdVC = [UIViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:firstVC];
    
    [nc pushViewController:secondVC animated:NO];
    XCTAssertEqualObjects(nc.ac_previousViewController, firstVC);
    
    [nc pushViewController:thirdVC animated:NO];
    XCTAssertEqualObjects(nc.ac_previousViewController, secondVC);
    
    [nc popToRootViewControllerAnimated:NO];
    XCTAssertNil(nc.ac_previousViewController);
}

- (void)testUITabBar {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, 100.0, 100.0)];
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(.0, 90.0, 100., 10.)];
    [view addSubview:tabBar];
    XCTAssertTrue(tabBar.ac_isVisible);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing async animation hidden"];
    [tabBar ac_hidden:YES animated:YES completion:^(BOOL finished) {
        XCTAssertFalse(tabBar.ac_isVisible);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1. handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testUITableViewCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Empty Cell ID"];
    [cell setFrame:CGRectMake(.0, .0, 320., 44.)];
    
    XCTAssertNotNil(cell.ac_separatorTop);
    XCTAssertTrue(cell.ac_separatorTop.hidden);
    XCTAssertGreaterThan(cell.ac_separatorTop.height, .0);
    
    XCTAssertNotNil(cell.ac_separatorBottom);
    XCTAssertTrue(cell.ac_separatorBottom.hidden);
    XCTAssertGreaterThan(cell.ac_separatorBottom.height, .0);
}

- (void)testUITableViewController {
    UITableViewController *tvc = [UITableViewController new];
    XCTAssertNil(tvc.refreshControl);
    
    [tvc ac_initRefreshView];
    XCTAssertNotNil(tvc.refreshControl);
    
    [tvc ac_startRefreshingTable];
    XCTAssertTrue(tvc.refreshControl.refreshing);
    
    [tvc ac_endRefreshingTable];
    XCTAssertFalse(tvc.refreshControl.refreshing);
}

- (void)testUITextView {
    UITextView *textView = [UITextView new];
    XCTAssertEqual(textView.ac_contentVerticalAlignment, ACContentVerticalAlignmentTop);
    
    [textView setAc_contentVerticalAlignment:ACContentVerticalAlignmentBottom];
    XCTAssertEqual(textView.ac_contentVerticalAlignment, ACContentVerticalAlignmentBottom);
    
    [textView setAc_contentVerticalAlignment:ACContentVerticalAlignmentCenter];
    XCTAssertEqual(textView.ac_contentVerticalAlignment, ACContentVerticalAlignmentCenter);
}

- (void)testUIView {
    UIView *view = [UIView new];
    
    [view setAc_staticBackgroundColor:[UIColor blackColor]];
    XCTAssertTrue([view.backgroundColor ac_isEqualToColor:[UIColor blackColor]]);
    
    [view setBackgroundColor:[UIColor redColor]];
    XCTAssertFalse([view.backgroundColor ac_isEqualToColor:[UIColor redColor]]);
    XCTAssertTrue([view.backgroundColor ac_isEqualToColor:[UIColor blackColor]]);
    
    [view setAc_staticBackgroundColor:nil];
    [view setBackgroundColor:[UIColor whiteColor]];
    XCTAssertFalse([view.backgroundColor ac_isEqualToColor:[UIColor clearColor]]);
    
    [view ac_setBackgroundClearColor];
    XCTAssertTrue([view.backgroundColor ac_isEqualToColor:[UIColor clearColor]]);
}

- (void)testUIViewController {
    UIViewController *vc = [UIViewController new];
    [vc viewDidLoad];
    XCTAssertFalse(vc.ac_isVisible);
    XCTAssertFalse(vc.ac_isViewAppearNotFirstTime);
    
    [vc viewWillAppear:NO];
    XCTAssertTrue(vc.ac_isVisible);
    
    [vc viewWillDisappear:NO];
    XCTAssertFalse(vc.ac_isVisible);
    XCTAssertTrue(vc.ac_isViewAppearNotFirstTime);
    
    [vc viewWillAppear:NO];
    XCTAssertTrue(vc.ac_isViewAppearNotFirstTime);
}

@end

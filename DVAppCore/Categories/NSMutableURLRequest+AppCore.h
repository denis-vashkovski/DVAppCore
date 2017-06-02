//
//  NSMutableURLRequest+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+AppCore.h"

#pragma mark - ACHTTPBodyData
@interface ACHTTPBodyData: NSObject{
    NSData *_data;
}
AC_STANDART_CREATING_NOT_AVAILABLE()
+ (instancetype)dataWithData:(NSData *)data;

@property (nonatomic, strong, readonly) NSData *data;
@end

#pragma mark ACHTTPImageBodyData
@interface ACHTTPImageBodyData: ACHTTPBodyData
+ (instancetype)dataWithData:(NSData *)data __attribute__((unavailable("dataWithData: not available, call (dataPNGWithImage:name: or dataJPGWithImage:compressionQuality:name:) instead")));
+ (instancetype)dataPNGWithImage:(UIImage *)image name:(NSString *)name;
+ (instancetype)dataJPGWithImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality name:(NSString *)name;
@end

#pragma mark - NSMutableURLRequest
@interface NSMutableURLRequest(AppCore)
- (void)ac_appendData:(NSArray<ACHTTPBodyData *> *)data;
@end

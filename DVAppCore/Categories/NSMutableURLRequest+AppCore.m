//
//  NSMutableURLRequest+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSMutableURLRequest+AppCore.h"

#import "NSArray+AppCore.h"
#import "NSURLRequest+AppCore.h"

AC_EXTERN_STRING_M_V(AC_BOUNDARY_KEY, @"------------------341E394BBE81499FB19D2E2185733939")
AC_EXTERN_STRING_M_V(AC_JPG_FORMAT, @"jpg")
AC_EXTERN_STRING_M_V(AC_PNG_FORMAT, @"png")

#pragma mark - ACHTTPBodyData
@implementation ACHTTPBodyData
+ (instancetype)dataWithData:(NSData *)data {
    return [[super alloc] initWithData:data];
}
- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        _data = data;
    }
    return self;
}
@end

#pragma mark ACHTTPImageBodyData
@implementation ACHTTPImageBodyData
+ (instancetype)dataPNGWithImage:(UIImage *)image name:(NSString *)name {
    return [super dataWithData:[self PNGDataWithImage:image name:name]];
}
+ (instancetype)dataJPGWithImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality name:(NSString *)name {
    return [super dataWithData:[self JPGDataWithImage:image compressionQuality:compressionQuality name:name]];
}
+ (NSData *)imageData:(NSData *)data name:(NSString *)name fileType:(NSString *)fileType {
    if (!ACValidStr(name)) {
        name = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:
                       @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"%@\r\n\r\n",
                       AC_BOUNDARY_KEY,
                       name,
                       [NSString stringWithFormat:@"%@.%@", name, ACUnnilStr(fileType)],
                       ([NSString stringWithFormat:@"\r\n%@: %@",
                         AC_HTTP_HEADER_KEY_CONTENT_TYPE,
                         AC_CONTENT_TYPE_APPLICATION_OCTET_STREAM])] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [NSData dataWithData:body];
}
+ (NSData *)PNGDataWithImage:(UIImage *)image name:(NSString *)name {
    return [self imageData:UIImagePNGRepresentation(image) name:name fileType:AC_PNG_FORMAT];
}
+ (NSData *)JPGDataWithImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality name:(NSString *)name {
    return [self imageData:UIImageJPEGRepresentation(image, compressionQuality) name:name fileType:AC_JPG_FORMAT];
}
@end

#pragma mark - NSMutableURLRequest
@implementation NSMutableURLRequest(AppCore)

- (void)ac_appendData:(NSArray<ACHTTPBodyData *> *)data {
    if (!ACValidArray(data)) return;
    
    [self setValue:[@"multipart/form-data; boundary=" stringByAppendingString:AC_BOUNDARY_KEY] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    for (ACHTTPBodyData *dataPart in data) {
        [body appendData:dataPart.data];
    }
    data = nil;
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", AC_BOUNDARY_KEY] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setHTTPBody:body];
    
    [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:AC_HTTP_HEADER_KEY_CONTENT_LENGTH];
}

@end

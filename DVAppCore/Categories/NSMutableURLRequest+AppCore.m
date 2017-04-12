//
//  NSMutableURLRequest+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSMutableURLRequest+AppCore.h"

#import "NSArray+AppCore.h"

@implementation NSMutableURLRequest(AppCore)

#define BOUNDARY_KEY @"unique-consistent-string"
- (void)ac_appendData:(NSArray<NSData *> *)data {
    if (!ACValidArray(data)) {
        return;
    }
    
    [self setValue:[@"multipart/form-data; boundary=%@" stringByAppendingString:BOUNDARY_KEY] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    for (id dataPart in data) {
        [body appendData:[[NSString stringWithFormat:
                           @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
                           BOUNDARY_KEY,
                           [NSUUID UUID].UUIDString,
                           dataPart] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    data = nil;
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY_KEY] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setHTTPBody:body];
    
    [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
}

@end

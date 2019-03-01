//
//  NSURLRequest+AppCore+Protected.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 01/03/2019.
//  Copyright © 2019 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest(AppCore_Protected)<NSURLSessionDelegate>
+ (NSString *)getApiFullUrlForHref:(NSString *)href;
- (void)ac_logRequest;
- (void)ac_logResponse:(NSHTTPURLResponse *)httpURLResponse
             startTime:(NSDate *)startTime
               jsonObj:(id)jsonObj;
@end

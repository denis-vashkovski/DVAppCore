//
//  NSURLRequest+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSURLRequest+AppCore.h"

#import "NSData+AppCore.h"
#import "NSMutableURLRequest+AppCore.h"
#import "NSString+AppCore.h"
#import "NSHTTPURLResponse+AppCore.h"

#import "ACConstants.h"
#import "ACLog.h"

AC_EXTERN_STRING_M(APIServerURL);

@implementation NSURLRequest(AppCore)

+ (void)ac_checkInternetConnection:(void (^)(BOOL))handler {
    NSMutableURLRequest *request = [self ac_requestGetByLink:@"http://google.com"].mutableCopy;
    [request setHTTPMethod:AC_HTTP_METHOD_HEAD];
    
    [request ac_sendAsynchronousWithCompletionHandler:^(id data, NSHTTPURLResponse *response) {
        if (handler) {
            handler(response.statusCode == AC_STATUS_CODE_OK);
        }
    }];
}

#pragma mark - GET
+ (NSURLRequest *)ac_requestGetByLink:(NSString *)link
                           parameters:(NSDictionary *)parameters
                         headerFields:(NSDictionary *)headerFields {
    NSMutableString *linkMutable = [NSMutableString stringWithString:link];
    
    if (parameters && parameters.count > 0) {
        BOOL first = YES;
        for (NSString *key in parameters) {
            [linkMutable appendString:(first ? @"?" : @"&")];
            [linkMutable appendString:[self prepareParameterWithKey:key value:parameters[key]]];
            first = NO;
        }
    }
    
    NSURL *url = [NSURL URLWithString:linkMutable];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    
    if (headerFields) {
        for (NSString *key in headerFields.allKeys) {
            [request addValue:headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    return request;
}

+ (NSURLRequest *)ac_requestGetByLink:(NSString *)link parameters:(NSDictionary *)parameters {
    return [self ac_requestGetByLink:link parameters:parameters headerFields:nil];
}

+ (NSURLRequest *)ac_requestGetByLink:(NSString *)link {
    return [self ac_requestGetByLink:link parameters:nil];
}

#pragma mark - GET Root link
+ (NSURLRequest *)ac_requestGetForRootLinkByHref:(NSString *)href
                                      parameters:(NSDictionary *)parameters
                                    headerFields:(NSDictionary *)headerFields {
    NSMutableString *linkWithVars = [NSMutableString stringWithString:[self getApiFullUrlForHref:href]];
    return [self ac_requestGetByLink:linkWithVars parameters:parameters headerFields:headerFields];
}

+ (NSURLRequest *)ac_requestGetForRootLinkByHref:(NSString *)href parameters:(NSDictionary *)parameters {
    return [self ac_requestGetForRootLinkByHref:href parameters:parameters headerFields:nil];
}

+ (NSURLRequest *)ac_requestGetForRootLinkByHref:(NSString *)href {
    return [self ac_requestGetForRootLinkByHref:href parameters:nil];
}

#pragma mark - POST Root link
+ (NSURLRequest *)ac_requestPostByLink:(NSString *)link body:(NSData *)body headerFields:(NSDictionary *)headerFields data:(NSArray<ACHTTPBodyData *> *)data {
    NSURL *url = [NSURL URLWithString:link];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:AC_HTTP_METHOD_POST];
    [request setHTTPShouldHandleCookies:NO];
    
    if (body) {
        [request setHTTPBody:body];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:AC_HTTP_HEADER_KEY_CONTENT_LENGTH];
    }
    
    [request ac_appendData:data];
    
    if (headerFields) {
        for (NSString *key in headerFields.allKeys) {
            [request addValue:headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    return request;
}

+ (NSURLRequest *)ac_requestPostByLink:(NSString *)link
                            parameters:(NSDictionary *)parameters
                          headerFields:(NSDictionary *)headerFields
                                  data:(NSArray<ACHTTPBodyData *> *)data {
    NSData *body = nil;
    
    if (ACValidDictionary(parameters)) {
        NSString *contentType = (ACValidDictionary(headerFields)
                                 ? headerFields[AC_HTTP_HEADER_KEY_CONTENT_TYPE]
                                 : nil);
        
        if ([contentType isEqualToString:AC_CONTENT_TYPE_APPLICATION_JSON]) {
            body = [parameters ac_jsonData];
        } else {
            NSMutableString *varsStr = [NSMutableString string];
            if (parameters && parameters.count > 0) {
                BOOL first = YES;
                for (NSString *key in parameters) {
                    if (!first) {
                        [varsStr appendString:@"&"];
                    }
                    first = NO;
                    
                    [varsStr appendString:[self prepareParameterWithKey:key value:parameters[key]]];
                }
            }
            
            body = [varsStr dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    return [self ac_requestPostByLink:link body:body headerFields:headerFields data:data];
}

+ (NSURLRequest *)ac_requestPostForRootLinkByHref:(NSString *)href
                                       parameters:(NSDictionary *)parameters
                                     headerFields:(NSDictionary *)headerFields
                                             data:(NSArray<ACHTTPBodyData *> *)data {
    return [self ac_requestPostByLink:[self getApiFullUrlForHref:href] parameters:parameters headerFields:headerFields data:data];
}

+ (NSURLRequest *)ac_requestPostForRootLinkByHref:(NSString *)href
                                       parameters:(NSDictionary *)parameters
                                     headerFields:(NSDictionary *)headerFields {
    return [self ac_requestPostForRootLinkByHref:href parameters:parameters headerFields:headerFields data:nil];
}

+ (NSURLRequest *)ac_requestPostForRootLinkByHref:(NSString *)href
                                       parameters:(NSDictionary *)parameters {
    return [self ac_requestPostForRootLinkByHref:href
                                      parameters:parameters
                                    headerFields:nil];
}

+ (NSURLRequest *)ac_requestPostForRootLinkByHref:(NSString *)href {
    return [self ac_requestPostForRootLinkByHref:href
                                      parameters:nil];
}

#pragma mark - PUT Root link
+ (NSURLRequest *)ac_requestPutByLink:(NSString *)link body:(NSData *)body headerFields:(NSDictionary *)headerFields data:(NSArray<ACHTTPBodyData *> *)data {
    NSMutableURLRequest *request = [[self ac_requestPostByLink:link
                                                          body:body
                                                  headerFields:headerFields
                                                          data:data] mutableCopy];
    [request setHTTPMethod:AC_HTTP_METHOD_PUT];
    
    return request;
}

+ (NSURLRequest *)ac_requestPutByLink:(NSString *)link parameters:(NSDictionary *)parameters headerFields:(NSDictionary *)headerFields data:(NSArray<ACHTTPBodyData *> *)data {
    NSMutableURLRequest *request = [[self ac_requestPostByLink:link
                                                    parameters:parameters
                                                  headerFields:headerFields
                                                          data:data] mutableCopy];
    [request setHTTPMethod:AC_HTTP_METHOD_PUT];
    
    return request;
}

+ (NSURLRequest *)ac_requestPutForRootLinkByHref:(NSString *)href parameters:(NSDictionary *)parameters headerFields:(NSDictionary *)headerFields data:(NSArray<ACHTTPBodyData *> *)data {
    return [self ac_requestPutByLink:[self getApiFullUrlForHref:href] parameters:parameters headerFields:headerFields data:data];
}

+ (NSURLRequest *)ac_requestPutForRootLinkByHref:(NSString *)href parameters:(NSDictionary *)parameters headerFields:(NSDictionary *)headerFields {
    return [self ac_requestPutForRootLinkByHref:href parameters:parameters headerFields:headerFields data:nil];
}

+ (NSURLRequest *)ac_requestPutForRootLinkByHref:(NSString *)href parameters:(NSDictionary *)parameters {
    return [self ac_requestPutForRootLinkByHref:href parameters:parameters headerFields:nil];
}

+ (NSURLRequest *)ac_requestPutForRootLinkByHref:(NSString *)href {
    return [self ac_requestPutForRootLinkByHref:href parameters:nil];
}

#pragma mark - DELETE Root link
+ (NSURLRequest *)ac_requestDeleteByLink:(NSString *)link body:(NSData *)body headerFields:(NSDictionary *)headerFields data:(NSArray<ACHTTPBodyData *> *)data {
    NSMutableURLRequest *request = [[self ac_requestPostByLink:link
                                                          body:body
                                                  headerFields:headerFields
                                                          data:data] mutableCopy];
    [request setHTTPMethod:AC_HTTP_METHOD_DELETE];
    
    return request;
}

+ (NSURLRequest *)ac_requestDeleteByLink:(NSString *)link parameters:(NSDictionary *)parameters headerFields:(NSDictionary *)headerFields data:(NSArray<ACHTTPBodyData *> *)data {
    NSMutableURLRequest *request = [[self ac_requestPostByLink:link
                                                    parameters:parameters
                                                  headerFields:headerFields
                                                          data:data] mutableCopy];
    [request setHTTPMethod:AC_HTTP_METHOD_DELETE];
    
    return request;
}

+ (NSURLRequest *)ac_requestDeleteForRootLinkByHref:(NSString *)href parameters:(NSDictionary *)parameters headerFields:(NSDictionary *)headerFields data:(NSArray<ACHTTPBodyData *> *)data {
    return [self ac_requestDeleteByLink:[self getApiFullUrlForHref:href] parameters:parameters headerFields:headerFields data:data];
}

+ (NSURLRequest *)ac_requestDeleteForRootLinkByHref:(NSString *)href parameters:(NSDictionary *)parameters headerFields:(NSDictionary *)headerFields {
    return [self ac_requestDeleteForRootLinkByHref:href parameters:parameters headerFields:headerFields data:nil];
}

+ (NSURLRequest *)ac_requestDeleteForRootLinkByHref:(NSString *)href parameters:(NSDictionary *)parameters {
    return [self ac_requestDeleteForRootLinkByHref:href parameters:parameters headerFields:nil];
}

+ (NSURLRequest *)ac_requestDeleteForRootLinkByHref:(NSString *)href {
    return [self ac_requestDeleteForRootLinkByHref:href parameters:nil];
}

#pragma mark - Send
// TODO add ACURLConnectionManager
// TODO add ACURLConnection
- (void)ac_sendAsynchronousWithCompletionHandler:(ACURLCompletionHadler)handler {
    [self ac_logRequest];
    
    NSDate *currentTime = [NSDate date];
    
    void (^completionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError) =
    ^void(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self ac_executeInMainThread:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        id jsonObj = nil;
        NSHTTPURLResponse *HTTPURLResponse = nil;
        
        if (response) {
            jsonObj = data.ac_jsonToCollectionObject;
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                HTTPURLResponse = (NSHTTPURLResponse *)response;
            }
        }
        
        [self ac_logResponse:HTTPURLResponse startTime:currentTime jsonObj:jsonObj];
        
        if (handler) {
            handler(jsonObj, HTTPURLResponse);
        }
    };
    
    [self ac_executeInMainThread:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:self
                completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          completionBlock(response, data, error);
      }] resume];
}

- (id)ac_sendSynchronousWithResponse:(NSHTTPURLResponse *__autoreleasing *)response {
    [self ac_logRequest];
    
    __block NSError *error = nil;
    __block NSURLResponse *urlResponse = nil;
    __block NSData *data = nil;
    
    [self ac_executeInMainThread:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }];
    
    NSDate *currentTime = [NSDate date];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:self completionHandler:
      ^(NSData *taskData, NSURLResponse *taskResponse, NSError *taskError) {
          data = taskData;
          urlResponse = taskResponse;
          error = taskError;
          dispatch_semaphore_signal(semaphore);
      }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self ac_executeInMainThread:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    if (urlResponse && [urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        *response = (NSHTTPURLResponse *)urlResponse;
    }
    
    id json = data ? data.ac_jsonToCollectionObject : nil;
    
    [self ac_logResponse:*response startTime:currentTime jsonObj:json];
    
    return json;
}

#pragma mark - Stub
- (id)stubData {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:self.URL resolvingAgainstBaseURL:NO];
    urlComponents.query = nil;
    
    NSString *urlWithoutQuery = urlComponents.string;
    NSString *apiMethodHref = [urlWithoutQuery stringByReplacingOccurrencesOfString:[self.class getApiServerUrl]
                                                                         withString:@""];
    NSString *stubFileName = [apiMethodHref stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    if (!ACValidStr(stubFileName)) return nil;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:stubFileName ofType:@"plist"];
    NSAssert(ACValidStr(plistPath), @"There isn't stub data file for '%@' request", stubFileName);
    
    NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
    if (!plistData) {
        NSLog(@"Error reading from file: %@", plistPath);
    }
    
    NSPropertyListFormat format;
    NSError *error = nil;
    id stubData = [NSPropertyListSerialization propertyListWithData:plistData
                                                            options:NSPropertyListImmutable
                                                             format:&format
                                                              error:&error];
    
    if (error) {
        NSLog(@"Error reading from plist: %@", error.localizedDescription);
    }
    
    return stubData;
}

#define MAX_PARAMETER_LENGTH 1000
- (void)ac_logRequest {
    NSURLRequest *requestCopy = [self copy];
    NSString *body = requestCopy.HTTPBody ? [[NSString alloc] initWithData:requestCopy.HTTPBody encoding:NSUTF8StringEncoding] : nil;
    if (body && (body.length > MAX_PARAMETER_LENGTH)) {
        body = [[body substringToIndex:MAX_PARAMETER_LENGTH] stringByAppendingString:@"..."];
    }
    
    NSLog(@"\nType: %@\nURL: %@\nHTTP Method: %@\nHTTP header fields: %@\nBody: %@",
          @"Request",
          (requestCopy ? ACUnnilStr(requestCopy.URL.absoluteString.ac_decodeForUrl) : @""),
          ACUnnilStr(requestCopy.HTTPMethod),
          (requestCopy.allHTTPHeaderFields ? ACUnnilStr(requestCopy.allHTTPHeaderFields.description) : @""),
          ACUnnilStr(body));
}

- (void)ac_logResponse:(NSHTTPURLResponse *)httpURLResponse startTime:(NSDate *)startTime jsonObj:(id)jsonObj {
    NSMutableString *responseLog = [NSMutableString new];
    [responseLog appendString:@"\nType: Response"];
    [responseLog appendFormat:@"\nURL: %@", httpURLResponse.URL.absoluteString.ac_decodeForUrl];
    [responseLog appendFormat:@"\nStatusCode: %ld", (httpURLResponse ? (long)httpURLResponse.statusCode : 0)];
    
    if (httpURLResponse && (httpURLResponse.statusCode != AC_STATUS_CODE_OK)) {
        [responseLog appendFormat:@"\nHTTP header fields: %@", ((httpURLResponse && httpURLResponse.allHeaderFields)
                                                                ? ACUnnilStr(httpURLResponse.allHeaderFields.description)
                                                                : @"")];
    }
    
    [responseLog appendFormat:@"\nDuration: %.0fms.", ABS(startTime.timeIntervalSinceNow) * 1000];
    [responseLog appendFormat:@"\nResponse: %@", jsonObj];
    
    NSLog(responseLog);
}

#pragma mark - Utils
+ (NSString *)getApiServerUrl {
    return AC_USER_DEFINED_BY_KEY(APIServerURL);
}

+ (NSString *)getApiFullUrlForHref:(NSString *)href {
    return [NSString stringWithFormat:@"%@%@", ACUnnilStr([self getApiServerUrl]), href];
}

+ (NSString *)prepareParameterWithKey:(NSString *)key value:(id)value {
    if (!ACValidStr(key) || !value) {
        return nil;
    }
    
    NSMutableString *parameter = [NSMutableString new];
    
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *valueArray = (NSArray *)value;
        if (valueArray.ac_isEmpty) {
            valueArray = @[ @"" ];
        }
        
        NSString *preparedKey = [key stringByAppendingString:@"[]"];
        for (NSString *v in valueArray) {
            [parameter appendString:[self prepareParameterWithKey:preparedKey value:v]];
            [parameter appendString:@"&"];
        }
        
        return [parameter substringToIndex:(parameter.length - 1)];
    }
    
    [parameter appendString:key.ac_encodeForUrl];
    [parameter appendString:@"="];
    
    NSString *parameterValueStr = @"";
    if ([value isKindOfClass:[NSString class]]) {
        parameterValueStr = value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        parameterValueStr = ((NSNumber *)value).stringValue;
    }
    
    [parameter appendString:[parameterValueStr ac_encodeForUrl]];
    
    return parameter;
}

@end

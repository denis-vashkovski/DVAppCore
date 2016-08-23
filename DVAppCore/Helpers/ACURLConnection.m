//
//  ACURLConnection.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 02/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACURLConnection.h"

#import "NSData+AppCore.h"

#import <UIKit/UIApplication.h>

@interface ACURLConnection()
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy) ACURLCompletionHadler completionHandler;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;
@end

@implementation ACURLConnection

+ (BOOL)ac_sendAsynchronousRequest:(NSURLRequest *)request completionHandler:(ACURLCompletionHadler)completionHandler {
    ACURLConnection *connection = [[ACURLConnection alloc] initWithRequest:request delegate:self];
    
    connection.connection = connection;
    connection.request = request;
    connection.completionHandler = completionHandler;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return (connection != nil);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
    self.response = (NSHTTPURLResponse *)aResponse;
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)bytes {
    [self.data appendData:bytes];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.error = error;
    [self connectionDidFinishLoading:connection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.completionHandler) {
        id preparedData = self.data ? self.data.ac_jsonToCollectionObject : nil;
        
        if ([ACURLConnectionManager getInstance].alwaysExecuteBeforeCompletionHandler) {
            [ACURLConnectionManager getInstance].alwaysExecuteBeforeCompletionHandler(preparedData, self.response);
        }
        
        self.completionHandler(preparedData, self.response);
        
        if ([ACURLConnectionManager getInstance].alwaysExecuteAfterCompletionHandler) {
            [ACURLConnectionManager getInstance].alwaysExecuteAfterCompletionHandler(preparedData, self.response);
        }
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([[ACURLConnectionManager getInstance].serversHostTrust containsObject:challenge.protectionSpace.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
                 forAuthenticationChallenge:challenge];
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end

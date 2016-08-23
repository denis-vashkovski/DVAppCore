//
//  ACURLConnectionManager.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 01/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACSingleton.h"

typedef void (^ACURLCompletionHadler)(id data, NSHTTPURLResponse *response);

@interface ACURLConnectionManager : NSObject
ACSINGLETON_H
@property (nonatomic, strong) NSDictionary *requestParamsDefault;
@property (nonatomic, strong) NSArray<NSString *> *serversHostTrust;
@property (nonatomic, strong) ACURLCompletionHadler alwaysExecuteBeforeCompletionHandler;
@property (nonatomic, strong) ACURLCompletionHadler alwaysExecuteAfterCompletionHandler;
@end

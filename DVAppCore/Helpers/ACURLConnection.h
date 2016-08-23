//
//  ACURLConnection.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 02/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACURLConnectionManager.h"

@interface ACURLConnection : NSURLConnection
+ (BOOL)ac_sendAsynchronousRequest:(NSURLRequest *)request completionHandler:(ACURLCompletionHadler)completionHandler;
@end

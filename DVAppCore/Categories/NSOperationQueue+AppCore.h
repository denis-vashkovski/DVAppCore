//
//  NSOperationQueue+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACAsyncBlockOperation.h"

@interface NSOperationQueue(AppCore)
- (void)addAsyncOperationWithBlock:(void (^)(ACAsyncBlockOperation *asyncBlockOperation))block;
@end
